class User < ApplicationRecord

  validates :email, presence: {message: "must be present."}
  validates :email, uniqueness: {message: "already exists."}
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

  has_secure_password
  
  has_many :goals
  has_many :life_goals
end
