module EncryptedFields
  class EncryptedField < EncryptedFields::ApplicationRecord
    belongs_to :data_encryption_key, class_name: "EncryptedFields::DataEncryptionKey"
    belongs_to :encryptable, polymorphic: true

    attr_encrypted :blob, key: proc { |ef| ef.send(:encryption_key) }

    def reencrypt!(new_key)
      # assigning the blob will trigger encryption with the new key
      update_attributes!(data_encryption_key: new_key, blob: blob)
    end

    private

    def encryption_key
      self.data_encryption_key ||= EncryptedFields::DataEncryptionKey.primary
      data_encryption_key.key
    end
  end
end
