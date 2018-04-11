# frozen_string_literal: true

module GdprExtension
  extend ActiveSupport::Concern
  class_methods do
    def has_personal_information? # rubocop:disable Naming/PredicateName
      false
    end

    # :reek:UtilityFunction
    def retention_period
      Rails.configuration.gdpr_retention_period
    end

    # by default most types of records should not disappear (eg. Users or Consents definitely should NOT)
    def can_expire?
      false
    end

    def outdated_records
      if can_expire?
        where("DATETIME(created_at, '+? seconds') < ?", retention_period, Time.current)
      else
        none # this way we can safely call this method but it won't delete anything
      end
    end

    def export_personal_information_from_model(_user_id)
      raise "method export_personal_information_from_model not defined"
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, GdprExtension)
