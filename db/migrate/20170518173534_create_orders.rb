class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :payment_method
      t.text :comment

      t.timestamps
    end
  end
end
