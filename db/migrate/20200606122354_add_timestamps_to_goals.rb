class AddTimestampsToGoals < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :goals, null: true 
    long_ago = DateTime.new(2020, 1, 1)
    Goal.update_all(created_at: long_ago, updated_at: long_ago)
  
    change_column_null :goals, :created_at, false
    change_column_null :goals, :updated_at, false
  end
end
