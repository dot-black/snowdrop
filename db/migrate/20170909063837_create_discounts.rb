class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :title
      t.string :description
      t.integer :value
      t.datetime :start_at, default: nil
      t.datetime :end_at,   default: nil

      t.timestamps
    end
    add_reference :products, :discount, default: nil, index: true
    add_column :line_items, :actual_price, :float
  end
end
