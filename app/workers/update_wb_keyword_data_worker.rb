class UpdateWbKeywordDataWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5

  def perform(keyword)
    raise 'WorkNotFinished' unless KeywordManager::WbKeywordsStatService.call(keyword)
  end
end
