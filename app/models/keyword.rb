class Keyword < ApplicationRecord
  has_and_belongs_to_many :items
  has_many :keyword_logs

  def self.update_keyword_info(keyword, results_count)
    update_keyword = Keyword.where(name: keyword)
    if update_keyword.nil? || update_keyword.empty?
      return false
    else
      update_keyword.update(results_count: results_count, last_collect_date: Date.today)
    end
  end
end
