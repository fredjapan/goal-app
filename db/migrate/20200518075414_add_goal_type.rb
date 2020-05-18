class AddGoalType < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :type, :string
  end
end
