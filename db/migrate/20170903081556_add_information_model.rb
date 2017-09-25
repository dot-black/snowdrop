class AddInformationModel < ActiveRecord::Migration[5.1]
  def change
    create_table :user_informations do |t|
      t.string :name
      t.string :telephone
      t.references :user, index: true

      t.timestamps
    end
    add_reference :orders, :user_information, index: true
    remove_column :users, :name, :string
    remove_column :users, :telephone, :string
  end
end
