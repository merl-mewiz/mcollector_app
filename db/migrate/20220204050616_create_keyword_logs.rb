class CreateKeywordLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :keyword_logs, id: false do |t|
      t.string :log_text
      t.datetime :log_date

      t.belongs_to :keyword, null: false, foreign_key: true
    end
  end
end
