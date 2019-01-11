# frozen_string_literal: true

# == Schema Information
#
# Table name: user_consents
#
#  id         :uuid             not null, primary key, indexed => [consented, up_to_date, user_id]
#  consented  :boolean          default(FALSE), not null, indexed => [consent_id, user_id, up_to_date], indexed => [up_to_date, user_id, id]
#  up_to_date :boolean          default(TRUE), not null, indexed => [consent_id, user_id, consented], indexed => [consented, user_id, id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  consent_id :uuid             indexed => [user_id, consented, up_to_date], indexed
#  user_id    :uuid             indexed => [consent_id, consented, up_to_date], indexed, indexed => [consented, up_to_date, id]
#
# Indexes
#
#  consented_to_index                 (consent_id,user_id,consented,up_to_date) WHERE ((consented = true) AND (up_to_date = true))
#  index_user_consents_on_consent_id  (consent_id)
#  index_user_consents_on_user_id     (user_id)
#  valid_consents                     (consented,up_to_date,user_id,id) WHERE ((consented = true) AND (up_to_date = true))
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
