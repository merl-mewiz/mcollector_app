class CreateWbStatKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :wb_stat_keywords, id: false do |t|
      t.string :sku, presence: true, length: { maximum: 20 }
      t.string :keyword, presence: true
      t.integer :position, presence: true
      t.datetime :search_date, presence: true
    end
  end
end
