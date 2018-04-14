# frozen_string_literal: true

# == Schema Information
#
# Table name: user_consents
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  consent_id :uuid
#  consented  :boolean          default(FALSE), not null
#  up_to_date :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :user_consent do
    user { create :user }
    consent { create :consent }
    consented false
    up_to_date true

    trait :expired do
      up_to_date false
    end

    trait :consented do
      consented true
    end
  end
end
