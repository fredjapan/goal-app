class User < ApplicationRecord

  validates :username, presence: {message: "must have a title."}
  validates :username, uniqueness: {message: "already exists."}

  has_secure_password
  
  has_many :goals
  has_many :life_goals
end
