class ItemsController < ApplicationController
  layout 'application_logged'
  before_action :authenticate_user!
  before_action :set_item, only: %i[show
                                    edit
                                    update
                                    destroy
                                    add_keyword
                                    get_info_by_sku
                                    del_item_keyword]

  # GET /items
  def index
    @items = current_user.items.paginate(page: params[:page])
  end

  # GET /items/:id
  def show
    item_keywords = @item.keywords
    @result_keywords = []
    item_keywords.each do |one_keyword|
      result_one_keyword = ItemOneKeyword.new(one_keyword.id, one_keyword.name)

      result_positions = {}
      positions = WbStatKeyword.where(sku: @item.sku, keyword: one_keyword.name).order(search_date: :asc).last(8)
      last_position = 0
      positions.each_with_index do |position, index|
        if index.zero?
          last_position = position.position
          next
        end

        result_positions[position.search_date] = [position.position, last_position - position.position]
        last_position = position.position
      end
      result_one_keyword.positions = result_positions
      @result_keywords.push result_one_keyword
    end

    @add_keyword_modal_url = add_keyword_path
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/:id/edit
  def edit
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    if @item.save
      flash[:success] = "Товар \"#{@item.name}\" создан."
      redirect_to item_url(@item)
    else
      flash.now[:danger] = errors_to_html(@item)
    end
  end

  # PATCH/PUT /items/:id
  def update
    if @item.update(item_params)
      flash[:success] = 'Данные успешно обновлены.'
    else
      flash[:danger] = errors_to_html(@item)
    end

    redirect_to edit_item_url(@item)
  end

  # DELETE /items/:id
  def destroy
    flash[:success] = "Товар \"#{@item.name}\" удален."
    @item.destroy

    redirect_to items_url
  end

  # POST /items/:id/addkeyword
  def add_keyword
    keyword = params[:keyword].downcase.strip
    @result = Keyword.where(name: keyword).first

    # добавляем если такого ключевого слова нет в таблице keywords
    unless @result
      @result = Keyword.new(name: keyword)
      @result.save
    end

    if @item.keywords.include? @result
      flash[:danger] = "Ключевое слово \"#{@result.name}\" уже есть у данного товара"
    else
      flash[:success] = "Ключевое слово \"#{@result.name}\" добавлено"
      @item.keywords << @result
    end

    redirect_to item_url(@item)
  end

  # DELETE /items/:id/delkeyword
  def del_item_keyword
    del_keyword = @item.keywords.find(params[:keyword_id])

    if del_keyword
      flash[:success] = "Ключевое слово \"#{del_keyword.name}\" удалено"
      @item.keywords.delete(del_keyword)
    else
      flash.now[:danger] = 'Ключевое слово не найдено'
    end

    redirect_to item_url(@item)
  end

  # POST /items/:id/
  def get_info_by_sku
    if @item.sku
      get_item = ItemsManager::GetItemInfoBySkuService.call(@item.sku)
      if get_item.is_a? KeywordManager::GetJsonFromOnePageService::Success
        @item.name = get_item[:item_data]['productInfo']['name']
        @item.preview_url = "https:#{get_item[:item_data]['colors'][0]['previewUrl']}"
        @item.brand_name = get_item[:item_data]['productInfo']['brandName']
        @item.brand_url = get_item[:item_data]['productInfo']['brandUrl']
        @item.brand_img_url = "https:#{get_item[:item_data]['productInfo']['brandImgUrl']}"
        if @item.save
          flash[:success] = 'Информация успешно обновлена'
        else
          flash[:danger] = 'Ошибка при сохранении данных'
        end
      else
        flash[:danger] = get_item[:message]
      end
    else
      flash[:danger] = 'Артикул не заполнен'
      redirect_to items_url
    end

    redirect_to edit_item_url(@item)
  end

  # POST /items/add-by-sku
  def add_by_sku
    sku = params[:sku]

    user_have_item = current_user.items.where(sku: sku).first
    if user_have_item
      flash[:danger] = 'Товар уже есть'
      redirect_to item_url(user_have_item.id)
    else
      new_item = ItemsManager::CreateItemBySkuService.call(sku, current_user)
      if new_item.is_a? ItemsManager::CreateItemBySkuService::Success
        flash[:success] = new_item[:message]

        redirect_to item_url(new_item[:item])
      else
        flash[:danger] = new_item[:message]

        redirect_to items_url
      end
    end
  end

  # POST /items/add-by-list
  def add_by_list
    @success_add = []
    @error_add = []

    items_list = params[:items_list].downcase
    strings = items_list.split("\n")

    strings.each do |str|
      str = str.strip.chomp
      user_have_item = current_user.items.where(sku: str).first

      if user_have_item
        @error_add.push "#{str}: Товар \"#{user_have_item.sku}\" уже есть"
      else
        new_item = ItemsManager::CreateItemBySkuService.call(str, current_user)

        if new_item.is_a? ItemsManager::CreateItemBySkuService::Success
          @success_add.push "#{str}: Товар \"#{new_item[:item].name}\" успешно создан"
        else
          @error_add.push "#{str}: #{new_item[:message]}"
        end
      end
    end
    flash[:danger] = get_flash_html(@error_add) if @error_add.count.positive?
    flash[:success] = get_flash_html(@success_add) if @success_add.count.positive?

    redirect_to items_url
  end

  private

  def get_flash_html(items)
    result = '<ul class="mb-0 pl-3">'
    items.each do |item|
      result += "<li>#{item}</li>"
    end

    result += '</ul>'
  end

  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :sku, :description, :user_id, :preview_url, :brand_name, :brand_url, :brand_img_url)
  end
end
