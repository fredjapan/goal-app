class AddRelatedGoalColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :parent_goal_id, :integer
  end
end
