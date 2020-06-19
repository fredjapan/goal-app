class AdminController < ApplicationController

  helper_method :sort_column, :sort_direction
  def index
    @users = User.order(sort_column + " " + sort_direction)
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
