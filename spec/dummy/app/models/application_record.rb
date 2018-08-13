class ApplicationRecord < ActiveRecord::Base
  include EncryptedFields::HasEncryptedFields

  self.abstract_class = true
end
