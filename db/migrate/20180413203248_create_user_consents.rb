class CreateUserConsents < ActiveRecord::Migration[5.2]
  def change
    create_table :user_consents, id: :uuid do |t|
      t.belongs_to :user, type: :uuid
      t.belongs_to :consent, type: :uuid
      t.boolean :consented, default: false, null: false
      t.boolean :up_to_date, default: true, null: false

      t.timestamps
    end

    # add_index :user_consents, :user, unique: true
  end
end
