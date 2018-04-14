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

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { create :user }

  it_behaves_like "an encryptable object", %i[email preferred_name username]

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it "exports data in a GDPR-compliant way" do
    expect(create(:user).export_personal_information).to be_json
  end

  describe "consented_to?" do
    let(:key) { user_consent.consent.key }

    context "when the user has consented" do
      let(:user_consent) { create :user_consent, :consented, user: user }

      it { expect(user).to be_consented_to(key) }
    end

    context "when the user has not consented" do
      let(:user_consent) { create :user_consent, user: user }

      it { expect(user).not_to be_consented_to(key) }
    end
  end
end
