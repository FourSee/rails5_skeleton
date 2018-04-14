class AddTranslatedFieldsToConsent < ActiveRecord::Migration[5.2]
  def change
    add_column :consents, :title_translations, :jsonb
    add_column :consents, :content_translations, :jsonb
  end
end
