module GoalsHelper

  def next_term(horizon)
    if horizon == "week"
      1.week
    elsif horizon == "quarter"
      3.months
    elsif horizon == "year"
      1.year
    end
  end

end
