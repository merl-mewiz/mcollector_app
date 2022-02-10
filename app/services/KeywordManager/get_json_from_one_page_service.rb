module KeywordManager
  class GetJsonFromOnePageService < ApplicationService
    def initialize(page_url)
      @page_url = page_url.strip
    end

    def call
      if @page_url.empty?
        result = Failure.new
        result[:message] = 'URL is empty'
        return result
      end

      begin
        resp = Net::HTTP.get_response(URI.parse(@page_url))
        page = JSON.parse(resp.body)
        # если вернулся пустой результат или произошла ошибка
        if page['state'] == -1
          result = Failure.new
          result[:message] = page['data']['errorMsg']
          return result
        end

        # при успехе возвращаем список товаров со страницы и информацию о
        # кол-ве страниц и кол-ве товаров
        result = Success.new
        result[:products] = page['data']['products']
        result[:pager] = page['data']['pager']
      rescue StandardError => e
        result = Failure.new
        result[:message] = e
      end

      result
    end
  end
end
