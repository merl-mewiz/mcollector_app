module KeywordManager

  class WbKeywordsStatService < ApplicationService
    def initialize(keyword)
      @keyword = keyword
    end

    def call
      keyword = Keyword.where(name: @keyword).first

      if keyword
        keyword.change_status!(1)
        result = KeywordManager::GetAllItemsByKeywordFromWbService.call(@keyword)

        if result.is_a? KeywordManager::GetAllItemsByKeywordFromWbService::Success
          items = result[:products]

          ActiveRecord::Base.transaction do
            WbStatKeyword.save_keyword_stat(@keyword, items)
            Keyword.update_keyword_info(@keyword, items.count)
          end

          KeywordLog.add_log_message(@keyword, result[:log_message])
          keyword.change_status!(0)
        else
          KeywordLog.add_log_message(@keyword, result[:message])
          items = []
          keyword.change_status!(-1)
        end
      end

      items
    end
  end
end
