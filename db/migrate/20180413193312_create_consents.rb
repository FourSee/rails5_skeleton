class CreateConsents < ActiveRecord::Migration[5.2]
  def change
    create_table :consents, id: :uuid do |t|
      t.timestamps
    end
  end
end
