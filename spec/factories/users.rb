# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :uuid             not null, primary key
#  encrypted_password          :string
#  encrypted_email_iv          :string
#  encrypted_email             :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  encrypted_preferred_name_iv :string
#  encrypted_preferred_name    :string
#  encrypted_username_iv       :string
#  encrypted_username          :string
#  email_hash                  :string           not null
#

FactoryBot.define do
  factory :user do
    sequence(:username) {|n| "username#{n}" }
    sequence(:email, User.count + 10_000) {|n| "email#{n}@domain.com" }
    sequence(:preferred_name) {|n| "preferred_name#{n}" }
  end
end
