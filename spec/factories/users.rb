# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :uuid             not null, primary key, indexed => [encrypted_email, encrypted_email_iv]
#  email_hash                  :string           not null, indexed
#  encrypted_email             :string           indexed => [id, encrypted_email_iv]
#  encrypted_email_iv          :string           indexed => [id, encrypted_email]
#  encrypted_password          :string
#  encrypted_preferred_name    :string
#  encrypted_preferred_name_iv :string
#  encrypted_username          :string
#  encrypted_username_iv       :string
#  uuid                        :uuid             indexed
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_users_on_email_hash  (email_hash) UNIQUE
#  index_users_on_uuid        (uuid) UNIQUE
#  user_email                 (id,encrypted_email,encrypted_email_iv)
#

FactoryBot.define do
  factory :user do
    sequence(:username) {|n| "username#{n}" }
    sequence(:email, User.count + 10_000) {|n| "email#{n}@domain.com" }
    sequence(:preferred_name) {|n| "preferred_name#{n}" }
  end
end
