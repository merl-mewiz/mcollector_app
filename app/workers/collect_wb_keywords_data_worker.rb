class CollectWbKeywordsDataWorker
  include Sidekiq::Worker

  def perform
    keywords = Keyword.all

    keywords.each do |keyword|
      UpdateWbKeywordDataWorker.perform_async(keyword.name)
    end
  end
end
