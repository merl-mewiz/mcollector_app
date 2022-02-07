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

  # ручной запуск обновления данных по ключевым словам
  def update_data
    keyword = params[:keyword].downcase.chomp.strip

    @keyword_data = KeywordManager::WbKeywordsStatService.call(keyword)

    render json: { keyword: keyword, results_count: @keyword_data.count, items: @keyword_data }
  end
end
