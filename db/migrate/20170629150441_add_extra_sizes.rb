class AddExtraSizes < ActiveRecord::Migration[5.1]
  def up
    add_column :categories, :complex, :boolean, default: false
    remove_column :products, :sizes
    add_column :products, :sizes, :jsonb
    remove_column :line_items, :size
    add_column :line_items, :size, :jsonb
  end
end
