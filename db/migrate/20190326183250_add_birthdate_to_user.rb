class AddBirthdateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :birthdate, :date, null: false
    add_column :users, :locale, :string, null: false, default: 'en'
  end
end
