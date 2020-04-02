class PagesController < ApplicationController
  def home
  	@nb_weekly_goals = 4
  	@weekly_goals = Weeklygoal.all
  end
  def update
  Weeklygoal.find(params[:id]).update title: params[:title]
  redirect_to "/"
  end
end
