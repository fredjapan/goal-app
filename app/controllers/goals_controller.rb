class GoalsController < ApplicationController

  def index
    @horizon = params[:horizon]
    @goals = Goal.where(horizon: @horizon)
  end
  
  def show
    id = params[:id]
    @goal = Goal.find(id)
  end

  def new
    @goal = Goal.new
    @related_goal = Goal.all
  end

  def edit
    id = params[:id]
    @goal = Goal.find(id)
  end

  def create
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
      redirect_to goals_path
    else
      render 'edit'
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to goals_path
  end

  def edit_multiple
    @horizon = params[:horizon]
    @goal = Goal.find(params[:goal_ids])
  end

  def update_multiple
    @goal = Goal.update(params[:goal].keys, params[:goal].values)
    redirect_to goals_path
  end

  def quarterly_index
    @goals = Goal.where(horizon: "quarterly")
    @horizon = params[:horizon]
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
