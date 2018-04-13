# frozen_string_literal: true

class RailsEnv
  def initialize
    load_environment_variables unless Rails.env.production?
    allow_encrypted_credentials
  end

  private

  def load_environment_variables
    return unless File.exist?(file_name)
    YAML.safe_load(File.open(file_name))[Rails.env].each do |key, value|
      self.class.send :define_method, key.downcase do
        value
      end
    end
  end

  def allow_encrypted_credentials
    self.class.send :define_method, :method_missing do |m, *_args, &_block|
      Rails.env.production? ? Rails.application.credentials.send(m) : nil
    end
  end

  def file_name
    File.join(Rails.root, "config", "credentials.yml")
  end
end
