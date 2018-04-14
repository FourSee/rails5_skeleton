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
#

class User < ApplicationRecord
  include Encryptable
  attr_encrypted :email, :preferred_name, :username, key: :encryption_key
  before_create :create_encryption_key
  after_create :save_encryption_key
  after_destroy :delete_encryption_key

  has_many :user_consents, -> { consented.up_to_date }, inverse_of: :user, dependent: :destroy
  has_many :consents, through: :user_consents, inverse_of: :users

  # entry point for exporting user's personal information
  def export_personal_information
    return unless persisted?
    descendants = ApplicationRecord.descendants.select(&:has_personal_information?)
    {}.tap do |result|
      descendants.each do |descendant|
        result[descendant.name] = descendant.export_personal_information(id)
      end
    end.to_json
  end

  # simplest example
  def self.export_personal_information(user_id)
    User.find(user_id).as_json(only: personal_information)
  end

  def self.personal_information
    %i[id short_id username preferred_name email updated_at created_at]
  end
end
