class DropWeekly < ActiveRecord::Migration[6.0]
  def change
  	drop_table :weekly
  end
end
