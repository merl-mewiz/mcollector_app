class KeywordLog < ApplicationRecord
  belongs_to :keyword

  def self.add_log_message(keyword, message)
    log_keyword = Keyword.where(name: keyword).first
    KeywordLog.create(keyword_id: log_keyword.id, log_text: message, log_date: DateTime.now) if log_keyword
  end
end
