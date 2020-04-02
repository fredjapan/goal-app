class Weekly < ActiveRecord::Migration[6.0]
  def change
  	create_table :weekly
  	add_column :weekly, :title, :string
  	add_column :weekly, :achievement, :string
  end
end
