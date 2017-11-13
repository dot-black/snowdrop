class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|

      t.string :kind
      t.string :social_type
      t.string :value

      t.timestamps
    end
  end
end
