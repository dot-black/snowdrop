class RemoveNameFromOrdersTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :name, :string
  end
end
