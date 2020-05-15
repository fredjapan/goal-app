class GoalsController < ApplicationController

  def index
    @goals = Weeklygoal.all
  end
  
  def show
    id = params[:id]
    @goal = Weeklygoal.find(id)
  end

  def new
    @goal = Weeklygoal.new
  end

  def edit
    id = params[:id]
    @goal = Weeklygoal.find(id)
  end

  def create
    @goal = Weeklygoal.new(goal_params)
    if @goal.save
      redirect_to goals_path
    else
      render 'new'
    end
  end

  def update
    id = params[:id]
    @goal = Weeklygoal.find(id)
    if @goal.update(goal_params)
      redirect_to goals_path
    else
      render 'edit'
    end
  end

  def destroy
    @goal = Weeklygoal.find(params[:id])
    @goal.destroy
    redirect_to goals_path
  end

  def edit_multiple
    @goal = Weeklygoal.find(params[:goal_ids])
  end

  def update_multiple
    @goal = Weeklygoal.update(params[:goal].keys, params[:goal].values)
    redirect_to goals_path
  end

  private
  # Using a private method to encapsulate the permissible parameters
  # is just a good pattern since you'll be able to reuse the same
  # permit list between create and update. Also, you can specialize
  # this method with per-user checking of permissible attributes.
  def goal_params
    params.require(:weeklygoal).permit(:title, :description, :achievement, :date)
  end
end
