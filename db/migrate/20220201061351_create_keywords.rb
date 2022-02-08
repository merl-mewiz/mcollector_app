class CreateKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :keywords do |t|
      t.string :name, null: false
      t.integer :results_count, default: 0
      t.datetime :last_collect_date
      t.integer :status, limit: 2, default: 0
      t.datetime :status_error_date
    end

    add_index :keywords, :name, unique: true
  end
end
