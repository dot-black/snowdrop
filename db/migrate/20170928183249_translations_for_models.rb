class TranslationsForModels < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :slug, :string
    reversible do |dir|
      dir.up do
        Category.create_translation_table! :title => :string
      end

      dir.down do
        Category.drop_translation_table!
      end
    end
  end
end
