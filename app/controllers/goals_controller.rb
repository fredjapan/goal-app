class GoalsController < ApplicationController
  def edit
    id = params[:id]
    @goal = Weeklygoal.find(id)
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

  def new
    @goal = Weeklygoal.new
  end

  def create
    @goal = Weeklygoal.new(goal_params)
    if @goal.save
      redirect_to goals_path
    else
      render 'new'
    end
  end

  def show
    id = params[:id]
    @goal = Weeklygoal.find(id)
  end

  def destroy
    id = params[:id]
    @goal = Weeklygoal.find(id)
    @goal.destroy!
    redirect_to goals_path
  end

  def index
    @goals = Weeklygoal.all
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
