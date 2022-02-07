class CreateKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :keywords do |t|
      t.string :name, null: false
      t.integer :results_count
      t.date :last_collect_date
      t.integer :parse_error
      t.date :parse_error_date
    end

    add_index :keywords, :name, unique: true
  end
end
