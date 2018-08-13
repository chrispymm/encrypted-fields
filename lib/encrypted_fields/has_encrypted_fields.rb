#
# Allows a specified  list of attributes on any ActiveRecord model to be encrypted
#
# All encrytped fields are stored in an encrypted_fields table reference by polymorphic association to the model (:encryptable).
#
#
# Usage
# ---------
#
# has_encrypted_fields *attributes
# e.g. has_encrypted_fields :email, :phone, :ssn
#
# Creates 3 dynamic methods on the model for each field (using the example field :email)
# these are an attr_writer, attr reader, and a method to find or initialize the EncryptedField record.
# email
# email=(val)
# email_encrypted_field

module EncryptedFields
  module HasEncryptedFields
    extend ActiveSupport::Concern

    class_methods do
      def has_encrypted_fields(*fields)
        # cattr_accessor :encryptable_fields, default: options || {}
        fields.each do |field|
          define_method "#{field}_encrypted_field" do
            # we use a select here as if we do a full ActiveRecord lookup for the field itself, we lose the link to the parent_object.encrypted_fields
            # this means updating the attributes of the field doesn't set Activerecord::Dirty correctly, and the item doesn't get saved when the parent object is saved.
            encrypted_fields.to_a.select{|ef| ef[:encryptable_field] == "#{field}"}.first || encrypted_fields.new(encryptable_field: "#{field}" )
          end
          private :"#{field}_encrypted_field"

          define_method "#{field}=" do |val|
            if val.blank?
              self.send("#{field}_encrypted_field").destroy #destroy the record
              encrypted_fields.reload # reload the association
            else
              self.send("#{field}_encrypted_field").blob = val
            end
          end

          define_method field do
            self.send("#{field}_encrypted_field").blob
          end
        end
      end
    end
    included do
      has_many :encrypted_fields, class_name: "EncryptedFields::EncryptedField", as: :encryptable, autosave: true, dependent: :destroy
    end
  end
end
