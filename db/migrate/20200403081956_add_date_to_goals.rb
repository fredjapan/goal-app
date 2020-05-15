class AddDateToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :weeklygoals, :date, :date
  end
end
