class AddEmailHashToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_hash, :string, null: false
    add_index :users, :email_hash, unique: true
  end
end
