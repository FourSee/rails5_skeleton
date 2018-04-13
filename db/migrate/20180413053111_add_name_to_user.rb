class AddNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_preferred_name_iv, :string
    add_column :users, :encrypted_preferred_name, :string
  end
end
