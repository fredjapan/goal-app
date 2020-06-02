class User < ApplicationRecord

  validates :username, presence: {message: "Goals must have a title."}
  validates :username, uniqueness: {message: "This username already exists."}

  has_secure_password
    
end
