class RemoveEmailHashFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :email_hash, :string
  end
end
