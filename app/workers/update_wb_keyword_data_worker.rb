class UpdateWbKeywordDataWorker
  include Sidekiq::Worker

  def perform(keyword)
    KeywordManager::WbKeywordsStatService.call(keyword)
  end
end
