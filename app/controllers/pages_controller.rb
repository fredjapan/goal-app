class PagesController < ApplicationController
  
  def home
    @goal_week_count = Goal.where(horizon: "week").count
    @goal_quarter_count = Goal.where(horizon: "quarter").count
    @goal_year_count = Goal.where(horizon: "year").count
    @goal_life_count = Goal.where(horizon: "life").count
    @goal_all_count = @goal_week_count + @goal_quarter_count + @goal_year_count + @goal_life_count
    @goal_week_achieved_count = Goal.where(horizon: "week", achievement: "achieved")
  end

end
