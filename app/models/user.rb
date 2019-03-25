# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :uuid             not null, primary key, indexed => [encrypted_email, encrypted_email_iv]
#  encrypted_email             :string           indexed => [id, encrypted_email_iv]
#  encrypted_email_bidx        :string           indexed
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
#  index_users_on_encrypted_email_bidx  (encrypted_email_bidx)
#  index_users_on_uuid                  (uuid) UNIQUE
#  user_email                           (id,encrypted_email,encrypted_email_iv)
#

class User < ApplicationRecord
  include Encryptable
  attr_encrypted :email, :preferred_name, :username, default_crypto_options
  blind_index :email, key: blind_index_key, expression: ->(v) { v.downcase }

  before_create :set_uuid
  before_create :create_encryption_key
  after_create :save_encryption_key
  after_destroy :delete_encryption_key

  has_many :user_consents, -> { consented.up_to_date }, inverse_of: :user, dependent: :destroy
  has_many :consents, through: :user_consents, inverse_of: :users

  validates :email, uniqueness: {case_sensitive: false}
  before_validation :monkeypatch_email_bidx

  scope :consented_to, ->(c) { joins(:user_consents).where(user_consents: {consent: c}) }

  # Required because the blind_index doesn't seem to like the email column
  def monkeypatch_email_bidx
    compute_email_bidx
  end

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

  # Can't just `pluck` like normal, since email is a virtual attribute
  def self.emails
    select(:id, :encrypted_email, :encrypted_email_iv).map(&:email)
  end

  def consented_to?(key)
    consents.find_by(key: key)
  end

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
