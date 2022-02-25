class AddPropertiesToItemsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :preview_url, :string
    add_column :items, :brand_name, :string
    add_column :items, :brand_url, :string
    add_column :items, :brand_img_url, :string
  end
end
