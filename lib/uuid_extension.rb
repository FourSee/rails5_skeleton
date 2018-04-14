# frozen_string_literal: true

module UuidExtension
  extend ActiveSupport::Concern
  included do
    default_scope -> { order(created_at: :asc) }
    def short_id
      Base62.encode(id.delete("-").hex)
    end
  end
end

# include the extension
ApplicationRecord.send(:include, UuidExtension)
