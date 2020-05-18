class RenameGoalTypeColumn < ActiveRecord::Migration[6.0]
  def change
      rename_column :goals, :type, :horizon
  end
end
