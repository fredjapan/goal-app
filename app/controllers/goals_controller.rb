class GoalsController < ApplicationController

  def index
    @horizon = params[:horizon]
    @goals = Goal.where(horizon: @horizon)
    @allgoals = Goal.all
  end
  
  def show
    @horizon = params[:horizon]
    id = params[:id]
    @goal = Goal.find(id)
  end

  def new
    @horizon = params[:horizon]
    @goal = Goal.new
    if @horizon == "week"
      @related_goal = Goal.where(horizon: "quarter")
    elsif @horizon == "quarter"
      @related_goal = Goal.where(horizon: "year")
    elsif @horizon == "year"
      @related_goal = Goal.where(horizon: "life")
    end
  end

  def edit
    id = params[:id]
    @goal = Goal.find(id)
  end

  def create
    @horizon = params[:horizon]
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to action: "index", horizon: @goal[:horizon]
    else
      render 'new'
    end
  end

  def update
    id = params[:id]
    @goal = Goal.find(id)
    if @goal.update(goal_params)
      redirect_to action: "index", horizon: @goal[:horizon]
    else
      render 'edit'
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to action: "index", horizon: @goal[:horizon]
  end

  def edit_multiple
    @horizon = params[:horizon]
    @goal = Goal.find(params[:goal_ids])
  end

  def update_multiple
    @horizon = params[:horizon]
    @goal = Goal.update(params[:goal].keys, params[:goal].values)
    redirect_to action: "index", horizon: @horizon
  end

  private
  # Using a private method to encapsulate the permissible parameters
  # is just a good pattern since you'll be able to reuse the same
  # permit list between create and update. Also, you can specialize
  # this method with per-user checking of permissible attributes.
  def goal_params
    params.require(:goal).permit(:title, :description, :achievement, :date, :horizon, :related_goal_id)
  end
end
