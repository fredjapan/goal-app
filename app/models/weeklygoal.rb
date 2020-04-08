class Weeklygoal < ActiveRecord::Base
  def week_start
    i = self.date.strftime('%Y%W')
    Date.commercial(i[0,4].to_i,i[4,2].to_i+1)
  end
end