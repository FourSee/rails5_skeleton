class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :encrypted_password
      t.string :username
      t.string :encrypted_email_iv
      t.string :encrypted_email

      t.timestamps
    end
  end
end
