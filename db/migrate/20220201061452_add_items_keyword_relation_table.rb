class AddItemsKeywordRelationTable < ActiveRecord::Migration[6.0]
  def change
    create_table :items_keywords, id: false do |t|
      t.belongs_to :item
      t.belongs_to :keyword
    end
  end
end
