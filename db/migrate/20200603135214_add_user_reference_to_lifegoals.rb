class AddUserReferenceToLifegoals < ActiveRecord::Migration[6.0]
  def change
    add_reference :life_goals, :user, foreign_key: true
  end
end
