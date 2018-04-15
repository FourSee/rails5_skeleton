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

require "rails_helper"

RSpec.describe UserConsent, type: :model do
  let(:consent) { create :consent }
  let!(:consented_user) { create :user, user_consents: [create(:user_consent, :consented, consent: consent)] }
  let!(:expired_consented_user) {
    create :user, user_consents: [create(:user_consent, :consented, :expired, consent: consent)]
  }
  let!(:revoked_consented_user) { create :user, user_consents: [create(:user_consent, consent: consent)] }
  let!(:non_consented_user) { create :user }

  it { expect(consent.users).to include(consented_user) }
  it { expect(consent.users).not_to include(non_consented_user) }
  it { expect(consent.users).not_to include(expired_consented_user) }
  it { expect(consent.users).not_to include(revoked_consented_user) }

  it "scopes User on consented_to" do
    expect(User.consented_to(consent)).to include(consented_user)
    expect(User.consented_to(consent)).not_to include(non_consented_user)
  end
end
