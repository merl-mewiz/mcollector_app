class ItemsController < ApplicationController
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
    @keywords_data = Hash.new
    @keywords.each do |keyword|
      result_positions = Hash.new
      @positions = WbStatKeyword.where(sku: @item.sku, keyword: keyword.name).order(search_date: :asc)
      @positions.each do |position|
        result_positions[position.search_date] = position.position
      end

      @keywords_data[keyword.name] = result_positions
    end
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
        format.html { redirect_to item_url(@item), notice: "Товар \"#{@item.name}\" создан." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: 'Данные успешно обновлены.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    item_name = @item.name
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Товар \"#{item_name}\" удален." }
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
