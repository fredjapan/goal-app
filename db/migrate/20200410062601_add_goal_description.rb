class AddGoalDescription < ActiveRecord::Migration[6.0]
  def change
    add_column :weeklygoals, :description, :text
  end
end
