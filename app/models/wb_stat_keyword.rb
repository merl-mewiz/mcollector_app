class WbStatKeyword < ApplicationRecord

  def self.save_keyword_stat(keyword, data = [])
    if data.any?
      data.each_with_index do |one_record, idx|
        WbStatKeyword.create(sku: one_record, keyword: keyword, position: idx + 1, search_date: DateTime.now)
      end

      return true
    end

    false
  end
end
