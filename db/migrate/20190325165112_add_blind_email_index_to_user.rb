class AddBlindEmailIndexToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_email_bidx, :string
    add_index :users, :encrypted_email_bidx
  end
end
