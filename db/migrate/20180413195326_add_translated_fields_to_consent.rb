class AddTranslatedFieldsToConsent < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Consent.create_translation_table! title: :string, content: :text
      end

      dir.down do
        Consent.drop_translation_table!
      end
    end
  end
end
