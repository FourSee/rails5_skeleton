# frozen_string_literal: true

module UuidExtension
  extend ActiveSupport::Concern
  included do
    def short_id
      Base62.encode(id.delete("-").hex)
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, UuidExtension)
