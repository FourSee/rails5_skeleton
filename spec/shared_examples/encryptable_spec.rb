# frozen_string_literal: true

require "spec_helper"

shared_examples_for "an encryptable object" do |encrypted_fields|
  let(:model) { build described_class.to_s.underscore }

  it "has all plaintext versions of all encrypted fields" do
    encrypted_fields.each {|f| expect(model).to respond_to(f) }
  end
end
