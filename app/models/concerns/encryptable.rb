# frozen_string_literal: true

module Encryptable
  extend ActiveSupport::Concern
  def redis_connection
    @redis_connection ||= ConnectionPool::Wrapper.new(size: ENV.fetch("REDIS_POOL", 5), timeout: 3) {
      Redis::Namespace.new(:encrypt, redis: Redis.new)
    }
  end

  def encryption_key
    @encryption_key ||= get_encryption_key
  end

  # Gotta clean up the :reek:TooManyStatements
  def get_encryption_key
    if self.class.name == "User"
      if persisted?
        return redis_connection.get(id)
      else # for new records
        return create_encryption_key
      end
    end
    if defined?(user_id)
      raise ArgumentError("Invalid user_id") unless user_id
      return redis_connection.get(user_id)
    else
      raise "You need to override an encryption_key method - no direct connection to user_id"
    end
  end

  def delete_encryption_key
    redis_connection.del(id)
  end

  # we might only need this in our User model but it's still part of our encryptable library
  # It's a :reek:UtilityFunction
  def create_encryption_key
    Rails.application.credentials.env.encryptable_seed + SecureRandom.random_bytes(28)
    # we take 4 bytes of our encryption_key from application secrets file wuth remaining 28 to be stored inside Redis
  end

  # attr_encrypted requires encrypted_fieldname_iv to exist in the database
  # This method will automatically populate all of them
  def populate_iv_fields
    fields = attributes.select {|attr| (attr.include?("iv") && attr.include?("encrypted")) }.keys
    fields.each do |field|
      unless public_send(field) # just in case so it's impossible to overwrite our iv
        iv = SecureRandom.random_bytes(12)
        public_send(field + "=", iv)
      end
    end
  end

  # this saves our encryption key in Redis so it's persistent
  def save_encryption_key
    key = if defined?(user_id)
            user_id.to_s
          else
            id.to_s
          end
    # just to stay on safe side
    raise "Encryption key already exists" if redis_connection.get(key)
    redis_connection.set(key, @encryption_key)
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
end
