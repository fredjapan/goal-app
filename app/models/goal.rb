class Goal < ActiveRecord::Base
  include GoalsHelper

  validates :title, presence: {message: "Goals must have a title."}
  validates :date, presence: {message: "Goals must have a deadline."}
  validates :horizon, presence: {message: "Goals must have a horizon."}
  validates :horizon, inclusion: { in: %w(week quarter year), message: "%{value} is not a valid horizon" }
  validates :achievement, inclusion: { in: ['achieved', 'partially achieved', 'failed', nil, ''], message: "%{value} is not a valid achievement" }

  belongs_to :user

  scope :date_later_than, ->(start_date) { where('date >= ?', start_date) }

  def this_term?(horizon)
    date >= DateTime.current.to_date.send("beginning_of_#{horizon}") && date <= DateTime.current.to_date.send("end_of_#{horizon}")
  end

  def next_term?(horizon)
    date >= next_term(horizon).from_now.to_date.send("beginning_of_#{horizon}") && date <= next_term(horizon).from_now.to_date.send("end_of_#{horizon}")
  end

end