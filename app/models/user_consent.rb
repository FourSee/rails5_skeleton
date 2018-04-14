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

class UserConsent < ApplicationRecord
  belongs_to :user, inverse_of: :user_consents
  belongs_to :consent, inverse_of: :user_consents
  scope :up_to_date, -> { where(up_to_date: true) }
  scope :consented, -> { where(consented: true) }
end
