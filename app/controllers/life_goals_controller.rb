class LifeGoalsController < ApplicationController

  def index
    @life_goals = LifeGoal.all.where(user: current_user)
  end

  def show
    id = params[:id]
    @life_goal = LifeGoal.find(id)
    respond_to do |format|
      format.js
    end
  end

  def new
    @life_goal = LifeGoal.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @life_goal = LifeGoal.new(life_goal_params.merge(user: current_user))
    if @life_goal.save
      render js: "window.location='#{life_goals_path}'"
    else
      respond_to do |format|
        format.js 
      end
    end
  end

  def edit
    id = params[:id]
    @life_goal = LifeGoal.find(id)
  end

  def update
    id = params[:id]
    @life_goal = LifeGoal.find(id)
    if @life_goal.update(life_goal_params)
      render js: "window.location='#{life_goals_path}'"
    else
      respond_to do |format|
        format.js 
      end
    end
  end

  def destroy
    @life_goal = LifeGoal.find(params[:id])
    if Goal.where(horizon: "year").where(parent_goal_id: params[:id]).present?
      @children_goals = Goal.where(horizon: "year").where(parent_goal_id: params[:id])
      @children_goals.each do |children_goal|
        children_goal[:parent_goal_id] = nil
        children_goal.save
      end
    end
    @life_goal.destroy
    redirect_to action: "index"
  end

  def edit_multiple
    @life_goals = LifeGoal.all.where(user: current_user)
  end

  def update_multiple
    @life_goals = LifeGoal.update(params[:life_goal].keys, params[:life_goal].values)
    @life_goals.reject { |p| p.errors.empty? }
    if @life_goals.empty?
      life_goals_path(horizon: @horizon, term: "term_this")
    else
      render edit_multiple_life_goals_path
    end
  end

  private

  def life_goal_params
    params.require(:life_goal).permit(:title, :what, :why)
  end

end
