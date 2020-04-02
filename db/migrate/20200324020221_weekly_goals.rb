class WeeklyGoals < ActiveRecord::Migration[6.0]
  def change
  	create_table :weekly_goals
  	add_column :weekly_goals, :title, :string
  	add_column :weekly_goals, :achievement, :string 
  end
end
