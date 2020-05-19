class Goal < ActiveRecord::Base

  validates :title, presence: {message: "Goals must have a title."}
  validates :date, presence: {message: "Goals must have a deadline."}
  validates :horizon, presence: {message: "Goals must have a horizon."}

  def this_week?
    date >= DateTime.current.to_date.beginning_of_week && date <= DateTime.current.to_date.end_of_week
  end

  def next_week?
    date >= 1.week.from_now.to_date.beginning_of_week && date <= 1.week.from_now.to_date.end_of_week
  end

  def beginning_of_horizon(horizon)
    send("beginning_of_#{horizon}")
  end

end