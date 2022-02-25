module ItemsHelper
  def wb_by_sku_path(sku)
    sku.empty? || sku.nil? ? '' : "https://napi.wildberries.ru/api/catalog/#{sku}/detail.aspx"
  end
end
