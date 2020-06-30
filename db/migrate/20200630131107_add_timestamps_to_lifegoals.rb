class AddTimestampsToLifegoals < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :life_goals, null: true 
    long_ago = DateTime.new(2020, 1, 1)
    LifeGoal.update_all(created_at: long_ago, updated_at: long_ago)
  
    change_column_null :life_goals, :created_at, false
    change_column_null :life_goals, :updated_at, false
  end
end
