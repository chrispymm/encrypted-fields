
module EncryptedFields
  class DataEncryptionKey < EncryptedFields::ApplicationRecord

    attr_encrypted :key, key: proc { |dek| dek.send(:key_encryption_key) }

    attr_writer :temporary_key


    class << self
      def primary
        find_by(primary: true)
      end

      def generate!(attrs={})
        create!(attrs.merge(key: SecureRandom.hex(16) ))
      end

      def unused
        where(primary: false).select do |key|
          EncryptedField.where(data_encryption_key_id: key.id).none?
        end
      end
    end

    def promote!
      transaction do
        EncryptedFields::DataEncryptionKey.primary.update_attributes!(primary: false)
        update_attributes!(primary: true)
      end
    end

    private

    def key_encryption_key
      @temporary_key || Rails.application.credentials.key_encryption_key
    end
  end
end
