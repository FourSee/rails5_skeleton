class AddKeyToConsent < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
    add_column :consents, :key, :citext, null: false
    add_index :consents, :key, unique: true
  end
end
