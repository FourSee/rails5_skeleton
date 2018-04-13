# frozen_string_literal: true

# FactoryBot.definition_file_paths = ["spec/factories"]
# FactoryBot.find_definitions

require "factory_bot_rails"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
