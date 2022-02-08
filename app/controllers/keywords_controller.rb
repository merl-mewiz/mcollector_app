class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @keywords = Keyword.all
  end

  def create
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

  # ручной запуск обновления данных по всем ключевым словам
  def update_all_data
    CollectWbKeywordsDataWorker.perform_async

    redirect_to keywords_url
  end
end
