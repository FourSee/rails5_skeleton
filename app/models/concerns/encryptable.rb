# frozen_string_literal: true

module Encryptable
  extend ActiveSupport::Concern

  class_methods do
    def default_crypto_options
      {
        encryptor: Lockbox::Encryptor,
        algorithm: "xchacha20",
        key:       :encryption_key
      }
    end

    def blind_index_key
      [Rails.application.credentials.env.blind_index_key].pack("H*")
    end
  end

  def redis_connection
    @redis_connection ||= $encryption_key_redis # rubocop:disable Style/GlobalVars
  end

  def encryption_key
    @encryption_key ||= get_or_generate_encryption_key
  end

  # Gotta clean up the :reek:TooManyStatements
  # rubocop:disable Naming/AccessorMethodName
  def get_or_generate_encryption_key
    if self.class.name == "User"
      return redis_connection.get(encryption_key_id) if persisted?

      return create_encryption_key
    end
    return redis_connection.get(encryption_key_id) if defined?(encryption_key_id)

    raise "You need to override an encryption_key method - no direct connection to user_id"
  end
  # rubocop:enable Naming/AccessorMethodName

  def delete_encryption_key
    redis_connection.del(encryption_key_id)
  end

  # we might only need this in our User model but it's still part of our encryptable library
  # It's a :reek:UtilityFunction
  def create_encryption_key
    SecureRandom.random_bytes(32).unpack1("H*")
  end

  # this saves our encryption key in Redis so it's persistent
  def save_encryption_key
    key = encryption_key_id
    # just to stay on safe side
    raise "Encryption key already exists" if redis_connection.get(key)

    redis_connection.set(key, encryption_key)
  end

  # what do return in attribute field when there's no key
  def value_when_no_key
    "[deleted]"
  end

  # we need to override attr_encrypted method so rather than throwing an exception
  # it will return a correct value when no key exists
  # you can also consider overriding encrypt in a similar fashion
  # (although for me it makes sense that no key = you cant edit whats inside)
  # :reek:DuplicateMethodCall happens a lot
  def decrypt(attribute, encrypted_value)
    encrypted_attributes[attribute.to_sym][:operation] = :decrypting
    encrypted_attributes[attribute.to_sym][:value_present] = self.class.not_empty?(encrypted_value)
    self.class.decrypt(attribute, encrypted_value, evaluated_attr_encrypted_options_for(attribute))
  rescue ArgumentError # must specify a key
    value_when_no_key
  end

  def encryption_key_id
    return uuid if self.class.name == "User" && defined?(uuid)

    user.try(:uuid)
  end
end
