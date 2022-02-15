class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @keywords = Keyword.paginate(page: params[:page], per_page: 30).order('name ASC')
    @add_keyword_modal_url = keywords_path
  end

  def create
    keyword = params[:keyword].downcase.chomp.strip

    @result = Keyword.where(name: keyword)

    if @result.nil? || @result.empty?
      @result = Keyword.new(name: keyword)
      @result.save
      flash[:success] = "Ключевое слово \"#{keyword}\" успешно добавлено"
    else
      flash[:danger] = "Ключевое слово \"#{keyword}\" уже есть в базе"
    end

    redirect_to keywords_path
  end

  def destroy
  end

  def view_log
    @keyword = Keyword.find(params[:id])
  end

  # ручной запуск обновления данных по одному ключевому слову
  def update_data
    keyword = params[:keyword].downcase.chomp.strip

    UpdateWbKeywordDataWorker.perform_async(keyword)

    redirect_to keywords_url
    # @keyword_data = KeywordManager::WbKeywordsStatService.call(keyword)
    # render json: { keyword: keyword, results_count: @keyword_data.count, items: @keyword_data }
  end

  # тестовый метод для получения данных по ключевому слову
  def update_data_test
    keyword = params[:keyword].downcase.chomp.strip

    @keyword_data = KeywordManager::GetAllItemsByKeywordFromWbService.call(keyword)
    if @keyword_data.is_a? KeywordManager::GetAllItemsByKeywordFromWbService::Success
      render json: { keyword: keyword, message: @keyword_data[:log_message], results_count: @keyword_data[:products].count, items: @keyword_data[:products] }
    else
      render json: { keyword: keyword, errorMessage: @keyword_data[:message] }
    end
  end

  # ручной запуск обновления данных по всем ключевым словам
  def update_all_data
    CollectWbKeywordsDataWorker.perform_async

    redirect_to keywords_url
  end
end
