class AddEncryptedUserameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_username_iv, :string
    add_column :users, :encrypted_username, :string
  end
end
