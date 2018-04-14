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

class Consent < ApplicationRecord
  translates :title, :content, touch: true

  validates :key, presence: true, uniqueness: {case_sensitive: false}

  has_many :user_consents, -> { consented.up_to_date }, inverse_of: :consent, dependent: :destroy
  has_many :users, through: :user_consents, inverse_of: :consents

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
end
