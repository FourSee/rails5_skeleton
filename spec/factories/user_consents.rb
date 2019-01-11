# frozen_string_literal: true

# == Schema Information
#
# Table name: user_consents
#
#  id         :uuid             not null, primary key, indexed => [consented, up_to_date, user_id]
#  consented  :boolean          default(FALSE), not null, indexed => [consent_id, user_id, up_to_date], indexed => [up_to_date, user_id, id]
#  up_to_date :boolean          default(TRUE), not null, indexed => [consent_id, user_id, consented], indexed => [consented, user_id, id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  consent_id :uuid             indexed => [user_id, consented, up_to_date], indexed
#  user_id    :uuid             indexed => [consent_id, consented, up_to_date], indexed, indexed => [consented, up_to_date, id]
#
# Indexes
#
#  consented_to_index                 (consent_id,user_id,consented,up_to_date) WHERE ((consented = true) AND (up_to_date = true))
#  index_user_consents_on_consent_id  (consent_id)
#  index_user_consents_on_user_id     (user_id)
#  valid_consents                     (consented,up_to_date,user_id,id) WHERE ((consented = true) AND (up_to_date = true))
#

FactoryBot.define do
  factory :user_consent do
    user { build :user }
    consent { build :consent }
    consented { false }
    up_to_date { true }

    trait :expired do
      up_to_date { false }
    end

    trait :consented do
      consented { true }
    end
  end
end
