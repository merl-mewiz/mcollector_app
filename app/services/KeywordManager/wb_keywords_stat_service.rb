module KeywordManager

  class WbKeywordsStatService < ApplicationService
    def initialize(keyword, start_page = 1)
      @keyword = keyword
      @start_page = start_page

      @page_url = 'https://napi.wildberries.ru/api/search/results'
      @keyword_param = '?search='
      @page_param = '&page='

      @pause_between_requests = 5 # задержка между запросами (сек)
      @pause_between_attempts = 20 # задержка между запросами при ошибке
      @retry_attempts = 20 # кол-во попыток при ошибке
    end

    def call
      keyword = Keyword.where(name: @keyword).first

      if keyword
        keyword.change_status!(1)

        items = get_items(@start_page)
        if items.any?
          ActiveRecord::Base.transaction do
            WbStatKeyword.save_keyword_stat(@keyword, items)
            Keyword.update_keyword_info(@keyword, items.count)
          end
        end
        keyword.change_status!(0)
      end

      items
    end

    private

    def get_items(page_num)
      ret_data = []
      retry_count = 0
      current_page = page_num
      last_page = 50
      page_size = 0
      total_items = 0

      while current_page <= last_page
        source = "#{@page_url}#{@keyword_param}#{CGI.escape(@keyword)}#{@page_param}#{current_page}"
        one_page = KeywordManager::GetJsonFromOnePageService.call(source)

        if one_page.is_a? KeywordManager::GetJsonFromOnePageService::Success
          # если это первая страница - заполняем основные данные
          if one_page[0][:pager]['currentPage'] == page_num
            last_page = one_page[0][:pager]['totalPages'] # сколько всего страниц по текущему запросу
            page_size = one_page[0][:pager]['pageSize'] # сколько товароы на странице
            total_items = one_page[0][:pager]['totalItems'] # сколько всего товаров
          end

          # если страница не последняя, то берем "pageSize - 1" (0..99) записей. с последней
          # страницы берем все записи
          ret_data += current_page != last_page ? one_page[0][:products][0..page_size - 1] : one_page[0][:products]
          break if last_page == 1

          current_page += 1
          retry_count = 0
          sleep(@pause_between_requests) # делаем паузу чтобы уменьшить частоту запросов
        else
          if retry_count >= @retry_attempts
            KeywordLog.add_log_message(@keyword, one_page[0][:message])
            break
          end

          sleep(@pause_between_attempts) # делаем долгую паузу если произошла ошибка
          retry_count += 1
        end
      end

      total1 = last_page * page_size
      total2 = last_page * page_size + 10

      unless (ret_data.count == total_items) || (ret_data.count == total1) || (ret_data.count == total2)
        KeywordLog.add_log_message(@keyword, "Количество товаров (#{ret_data.count}) не совпадает с данными API")
        ret_data = []
      end

      KeywordLog.add_log_message(@keyword, "Собрано товаров (#{ret_data.count}), из них уникальных (#{ret_data.uniq.count}), по данным API: (#{total_items}) / (#{total1}) / (#{total2})")

      ret_data.uniq
    end
  end
end
