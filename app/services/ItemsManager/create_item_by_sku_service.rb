module ItemsManager
  class CreateItemBySkuService < ApplicationService
    def initialize(sku, user)
      @sku = sku.strip
      @user = user
    end

    def call
      if @sku.empty?
        result = Failure.new
        result[:message] = 'Артикул не указан'

        return result
      end

      get_item = ItemsManager::GetItemInfoBySkuService.call(@sku)
      if get_item.is_a? ItemsManager::GetItemInfoBySkuService::Success
        # сохранить товар
        @item = Item.create(name: get_item[:item_data]['productInfo']['name'],
                            sku: @sku,
                            description: get_item[:item_data]['productInfo']['brandName'],
                            preview_url: "https:#{get_item[:item_data]['colors'][0]['previewUrl']}",
                            brand_name: get_item[:item_data]['productInfo']['brandName'],
                            brand_url: get_item[:item_data]['productInfo']['brandUrl'],
                            brand_img_url: "https:#{get_item[:item_data]['productInfo']['brandImgUrl']}",
                            user_id: @user.id)
        if @item
          result = Success.new
          result[:item] = @item
          result[:message] = "Товар \"#{@item.name}\" создан"
        else
          result = Failure.new
          result[:message] = 'Ошибка при создании товара'
        end
      else
        result = Failure.new
        result[:message] = get_item[:message]
      end

      result
    end
  end
end
