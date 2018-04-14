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

require "rails_helper"

RSpec.describe Consent, type: :model do
  subject(:consent) { build :consent }

  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  it { is_expected.to validate_presence_of(:key) }
end
