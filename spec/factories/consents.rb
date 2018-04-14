# frozen_string_literal: true

# == Schema Information
#
# Table name: consents
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  key        :citext           not null
#

FactoryBot.define do
  factory :consent do
    sequence(:key) {|n| "consent#{n}" }
  end
end
