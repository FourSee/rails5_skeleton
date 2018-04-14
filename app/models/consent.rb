# frozen_string_literal: true

# == Schema Information
#
# Table name: consents
#
#  id                   :uuid             not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  title_translations   :jsonb
#  content_translations :jsonb
#  key                  :citext           not null
#

class Consent < ApplicationRecord
  translates :title, :content

  validates :key, presence: true, uniqueness: {case_sensitive: false}

  has_many :user_consents, -> { consented.up_to_date }, inverse_of: :consent, dependent: :destroy
  has_many :users, through: :user_consents, inverse_of: :consents
  after_save :expire_user_consents

  # Can't just `pluck` like normal, since email is a virtual attribute
  def emails
    users.map(&:email)
  end

  # Can't just `pluck` like normal, since username is a virtual attribute
  def usernames
    users.map(&:username)
  end

  # Can't just `pluck` like normal, since preferred_name is a virtual attribute
  def preferred_names
    users.map(&:preferred_name)
  end

  private

  def expire_user_consents
    # This can also be done with an array intersection, but this is faster for small arrays
    # https://stackoverflow.com/a/3941963
    return unless saved_changes.keys.any? {|c| %w[title_translations content_translations].include?(c) }
    user_consents.update_all(up_to_date: false, updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
  end
end
