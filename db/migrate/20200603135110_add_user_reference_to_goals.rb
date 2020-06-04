class AddUserReferenceToGoals < ActiveRecord::Migration[6.0]
  def change
    add_reference :goals, :user, foreign_key: true
  end
end
