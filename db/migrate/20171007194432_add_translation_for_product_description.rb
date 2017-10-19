class AddTranslationForProductDescription < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        Product.create_translation_table! :description => :string
      end

      dir.down do
        Product.drop_translation_table!
      end
    end
  end
end
