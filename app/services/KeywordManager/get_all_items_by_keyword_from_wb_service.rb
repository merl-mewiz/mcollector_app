module KeywordManager

  class GetAllItemsByKeywordFromWbService < ApplicationService
    def initialize(keyword)
      @keyword = keyword
      @start_page = 1

      @page_url = 'https://napi.wildberries.ru/api/search/results'
      @keyword_param = '?search='
      @page_param = '&page='

      @pause_between_requests = 5 # задержка между запросами (сек)
      @pause_between_attempts = 20 # задержка между запросами при ошибке
      @retry_attempts = 20 # кол-во попыток при ошибке
    end

    def call()
      ret_data = []
      retry_count = 0
      current_page = 1
      last_page = 50
      page_size = 0
      total_items = 0

      while current_page <= last_page
        source = "#{@page_url}#{@keyword_param}#{CGI.escape(@keyword)}#{@page_param}#{current_page}"
        one_page = KeywordManager::GetJsonFromOnePageService.call(source)

        if one_page.is_a? KeywordManager::GetJsonFromOnePageService::Success
          # если это первая страница - заполняем основные данные
          if one_page[:pager]['currentPage'] == current_page
            last_page = one_page[:pager]['totalPages'] # сколько всего страниц по текущему запросу
            page_size = one_page[:pager]['pageSize'] # сколько товароы на странице
            total_items = one_page[:pager]['totalItems'] # сколько всего товаров
          end

          # если страница не последняя, то берем "pageSize - 1" (0..99) записей. с последней
          # страницы берем все записи
          ret_data += current_page != last_page ? one_page[:products][0..page_size - 1] : one_page[:products]
          break if last_page == 1

          current_page += 1
          retry_count = 0
          sleep(@pause_between_requests) # делаем паузу чтобы уменьшить частоту запросов
        elsif one_page.is_a? KeywordManager::GetJsonFromOnePageService::Failure
          return one_page if retry_count >= @retry_attempts

          sleep(@pause_between_attempts) # делаем долгую паузу если произошла ошибка
          retry_count += 1
        else
          result = Failure.new
          result[:message] = 'Unknown error'
          return result
        end
      end

      total1 = last_page * page_size
      total2 = last_page * page_size + 10

      unless (ret_data.count == total_items) || (ret_data.count == total1) || (ret_data.count == total2)
        # KeywordLog.add_log_message(@keyword, "Количество товаров (#{ret_data.count}) не совпадает с данными API")
        result = Failure.new
        result[:message] = "Количество товаров (#{ret_data.count}) не совпадает с данными API"
        return result
      end

      # KeywordLog.add_log_message(@keyword, "Собрано товаров (#{ret_data.count}), из них уникальных (#{ret_data.uniq.count}), по данным API: (#{total_items}) / (#{total1}) / (#{total2})")
      result = Success.new
      result[:products] = ret_data.uniq
      result[:log_message] = "Собрано товаров (#{ret_data.count}), из них уникальных (#{ret_data.uniq.count}), по данным API: (#{total_items}) / (#{total1}) / (#{total2})"

      result
    end
  end
end
