class CreateTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :translations do |t|
      t.string :attribute_name, null: false
      t.text :value
      t.string :locale, null: false
      t.integer :translateable_id
      t.string  :translateable_type
      t.timestamps
    end
    add_index :translations, [:translateable_type, :translateable_id]
  end
end
