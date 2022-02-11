class UpdateWbKeywordDataWorker
  include Sidekiq::Worker

  # WorkNotFinished = Class.new(StandardError)
  # retry_on WorkNotFinished, wait: 3.minutes
  sidekiq_options retry: 5

  def perform(keyword)
    raise 'WorkNotFinished' unless KeywordManager::WbKeywordsStatService.call(keyword)
  end
end
