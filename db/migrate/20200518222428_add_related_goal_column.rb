class AddRelatedGoalColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :related_goal_id, :integer
  end
end
