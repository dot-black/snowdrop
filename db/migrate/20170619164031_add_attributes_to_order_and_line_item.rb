class AddAttributesToOrderAndLineItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :order, index: true
    add_column :orders, :email, :string
    add_column :orders, :amount, :string
    add_column :orders, :status, :integer, default: 0
    remove_column :orders, :payment_method
  end
end
