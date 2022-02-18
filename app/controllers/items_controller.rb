class ItemsController < ApplicationController
  layout 'application_logged'
  before_action :authenticate_user!
  before_action :set_item, only: %i[show edit update destroy add_keyword]

  # GET /items or /items.json
  def index
    # @items = Item.all
    @items = current_user.items
  end

  # GET /items/1 or /items/1.json
  def show
    @keywords = @item.keywords
    @keywords_data = {}
    @keywords.each do |keyword|
      result_positions = {}
      @positions = WbStatKeyword.where(sku: @item.sku, keyword: keyword.name).order(search_date: :asc).last(8)
      last_position = 0
      @positions.each_with_index do |position, index|
        if index.zero?
          last_position = position.position
          next
        end

        result_positions[position.search_date] = [position.position, last_position - position.position]
        last_position = position.position
      end

      @keywords_data[keyword.name] = result_positions
    end
    @add_keyword_modal_url = add_keyword_path
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    respond_to do |format|
      if @item.save
        format.html do
          flash[:success] = "Товар \"#{@item.name}\" создан."
          redirect_to item_url(@item)
        end
        format.json { render :show, status: :created, location: @item }
      else
        format.html do
          flash.now[:danger] = errors_to_html(@item)
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html do
          flash[:success] = 'Данные успешно обновлены.'
          redirect_to item_url(@item)
        end
        format.json { render :show, status: :ok, location: @item }
      else
        format.html do
          flash.now[:danger] = errors_to_html(@item)
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    item_name = @item.name
    @item.destroy

    respond_to do |format|
      format.html do
        flash[:success] = "Товар \"#{item_name}\" удален."
        redirect_to items_url
      end
      format.json { head :no_content }
    end
  end

  def add_keyword
    keyword = params[:keyword].downcase.chomp.strip

    @result = Keyword.where(name: keyword)

    if @result.nil? || @result.empty?
      @result = Keyword.new(name: keyword)
      @result.save
    end

    @item.keywords << @result

    redirect_to item_url(@item)
  end

  def add_by_sku
    sku = params[:sku].strip

    if user_have_item = current_user.items.where(sku: sku).first
      flash[:danger] = 'Товар уже есть'
      redirect_to item_url(user_have_item.id)
    else
      # запросить товар по API
      get_item = ItemsManager::GetItemInfoBySkuService.call(sku)
      if get_item.is_a? KeywordManager::GetJsonFromOnePageService::Success
        # сохранить товар
        @item = Item.create(name: get_item[:item_data]['productInfo']['name'],
                            sku: sku,
                            description: get_item[:item_data]['productInfo']['brandName'],
                            user_id: current_user.id)
        flash[:success] = "Товар \"#{@item.name}\" создан."

        redirect_to item_url(@item)
      else
        # вернуть ошибку
        flash[:danger] = get_item[:message]
        redirect_to items_url
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :sku, :description, :user_id)
  end
end
