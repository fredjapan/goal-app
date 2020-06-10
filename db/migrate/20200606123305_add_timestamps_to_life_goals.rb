class AddTimestampsToLifeGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :life_goals, :created_at, :datetime, null: false
    add_column :life_goals, :updated_at, :datetime, null: false
  end
end
