class AddProductProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :sizes, :integer, array: true, default: []
    add_column :products, :priority, :integer, default: 1
    add_column :products, :visible, :boolean, default: false
    add_column :products, :archive, :boolean, default: false
  end
end
