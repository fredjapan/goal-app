class LifeGoal < ActiveRecord::Base

  validates :title, presence: {message: "Goals must have a title."}

  belongs_to :user
  
end