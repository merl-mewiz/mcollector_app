class UpdateWbKeywordDataWorker
  include Sidekiq::Worker

  # WorkNotFinished = Class.new(StandardError)
  # retry_on WorkNotFinished, wait: 3.minutes

  def perform(keyword)
    KeywordManager::WbKeywordsStatService.call(keyword)
  end
end
