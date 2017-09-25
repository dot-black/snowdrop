class AddUserOrderDependency < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :user, index: true
    add_column :users, :name, :string
    add_column :users, :telephone, :string
    remove_column :orders, :email, :string
    remove_column :orders, :telephone, :string
    remove_column :categories, :complex, :boolean
  end
end
