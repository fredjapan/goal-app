class AdminController < ApplicationController

  helper_method :sort_column, :sort_direction
  def index
    @users = User.order(sort_column + " " + sort_direction)
    @users = @users.map{|user| [user, user.goals.count + user.life_goals.count]}
    @users = @users.sort_by{|array| array[1]} if params[:sort_by_goal] == "asc"
    @users = @users.sort_by{|array| array[1]}.reverse if params[:sort_by_goal] == "desc"
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
