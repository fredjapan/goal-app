class PagesController < ApplicationController
  
  def home
    @goal_week_count = Goal.where(horizon: "week").count
    @goal_quarter_count = Goal.where(horizon: "quarter").count
    @goal_year_count = Goal.where(horizon: "year").count
    @goal_life_count = Goal.where(horizon: "life").count

    def achievment_percentage(horizon, achievement)
      total_goal_withachievment = Goal.where(horizon: horizon).where.not(achievement: [nil, ""]).count
      goal_achievement_count = Goal.where(horizon: horizon, achievement: achievement).count
      goal_achievement_count.to_f / total_goal_withachievment.to_f
    end
    
    @goal_week_achieved_percentage = achievment_percentage("week", "achieved")
    @goal_week_partiallyachieved_percentage = achievment_percentage("week", "partially achieved")
    @goal_week_failed_percentage = achievment_percentage("week", "failed")
    @goal_quarter_achieved_percentage = achievment_percentage("quarter", "achieved")
    @goal_quarter_partiallyachieved_percentage = achievment_percentage("quarter", "partially achieved")
    @goal_quarter_failed_percentage = achievment_percentage("quarter", "failed")
    @goal_year_achieved_percentage = achievment_percentage("year", "achieved")
    @goal_year_partiallyachieved_percentage = achievment_percentage("year", "partially achieved")
    @goal_year_failed_percentage = achievment_percentage("year", "failed")
  end

end
