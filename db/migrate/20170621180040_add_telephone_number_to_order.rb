class AddTelephoneNumberToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :telephone, :string
  end
end
