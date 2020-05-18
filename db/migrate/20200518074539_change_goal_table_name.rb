class ChangeGoalTableName < ActiveRecord::Migration[6.0]
  def change
    rename_table :weeklygoals, :goals
  end
end
