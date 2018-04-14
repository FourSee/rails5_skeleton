# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConsentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/consents").to route_to("consents#index")
    end

    it "routes to #show" do
      expect(get: "/consents/1").to route_to("consents#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/consents").to route_to("consents#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/consents/1").to route_to("consents#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/consents/1").to route_to("consents#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/consents/1").to route_to("consents#destroy", id: "1")
    end
  end
end
