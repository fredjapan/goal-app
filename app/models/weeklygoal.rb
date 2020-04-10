class Weeklygoal < ActiveRecord::Base

  validates :title, presence: {message: "Goals must have a title."}
  validates :date, presence: {message: "Goals must have a deadline."}

  def week_start
    i = self.date.strftime('%Y%W')
    Date.commercial(i[0,4].to_i,i[4,2].to_i+1)
  end

  def this_week?
    date >= DateTime.current.to_date.beginning_of_week && date <= DateTime.current.to_date.end_of_week
  end

  def next_week?
    date >= 1.week.from_now.to_date.beginning_of_week && date <= 1.week.from_now.to_date.end_of_week
  end

end