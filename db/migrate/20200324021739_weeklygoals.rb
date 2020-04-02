class Weeklygoals < ActiveRecord::Migration[6.0]
  def change
  	create_table :weeklygoals
  	add_column :weeklygoals, :title, :string
  	add_column :weeklygoals, :achievement, :string
  end
end
