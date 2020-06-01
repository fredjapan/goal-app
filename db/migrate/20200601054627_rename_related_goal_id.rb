class RenameRelatedGoalId < ActiveRecord::Migration[6.0]
  def change
    rename_column :goals, :parent_goal_id, :parent_goal_id
  end
end
