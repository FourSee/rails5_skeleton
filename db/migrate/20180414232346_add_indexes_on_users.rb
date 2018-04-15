class AddIndexesOnUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, [:id, :encrypted_email, :encrypted_email_iv], name: :user_email
    add_index :user_consents, [:consented, :up_to_date, :user_id, :id], where: "consented = true AND up_to_date = true", name: :valid_consents
    add_index :user_consents, [:consent_id, :user_id, :consented, :up_to_date], name: :consented_to_index, where: "consented = true AND up_to_date = true"
  end
end
