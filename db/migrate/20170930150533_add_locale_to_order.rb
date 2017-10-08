class AddLocaleToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :locale, :string, default: I18n.default_locale
  end
end
