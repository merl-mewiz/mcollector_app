module ItemsManager
  class GetItemInfoBySkuService < ApplicationService
    def initialize(sku)
      @sku = sku.strip
      @page_url = "https://napi.wildberries.ru/api/catalog/#{@sku}/detail.aspx"
    end

    def call
      if @sku.empty?
        result = Failure.new
        result[:message] = 'Артикул не указан'

        return result
      end

      begin
        resp = Net::HTTP.get_response(URI.parse(@page_url))
        page = JSON.parse(resp.body)

        # если вернулся пустой результат или произошла ошибка
        if page['state'] == -1 || page['error'] == 'not found'
          result = Failure.new
          result[:message] = page['error']['errorMsg'] || 'Товар не найден'

          return result
        end
        # при успехе возвращаем список товаров со страницы и информацию о
        # кол-ве страниц и кол-ве товаров
        result = Success.new
        result[:item_data] = page['data']
      rescue StandardError => e
        result = Failure.new
        result[:message] = e
      end

      result
    end
  end
end
