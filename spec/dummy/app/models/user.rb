class User < ApplicationRecord

  has_encrypted_fields :email, :phone, :ssn

end
