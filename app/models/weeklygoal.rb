class Weeklygoal < ActiveRecord::Base
  def week
    self.date.strftime('%Y%W')
  end
end