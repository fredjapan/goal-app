class CreateLifeGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :life_goals do |t|
      t.string "title"
      t.text "what"
      t.text "why"
    end
  end
end
