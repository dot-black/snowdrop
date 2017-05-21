class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :image
      t.float :price

      t.timestamps
    end
  end
end
