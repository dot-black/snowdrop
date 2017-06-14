class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.string :image
      t.boolean :visible, default: false

      t.timestamps
    end
    rename_column :products, :category, :category_id
  end
end
