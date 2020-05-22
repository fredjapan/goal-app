class GoalsController < ApplicationController

  def index
    @horizon = params[:horizon]
    @term = params[:term]
    def goals_scope(horizon, term)
      if term == "term_previous"
        Goal.where(horizon: horizon).where('date < ?', DateTime.current.to_date.send("beginning_of_#{horizon}"))
      elsif term == "term_next"
        Goal.where(horizon: horizon).where('date > ?', DateTime.current.to_date.send("end_of_#{horizon}"))
      else
        Goal.where(horizon: horizon).where('date >= ?', DateTime.current.to_date.send("beginning_of_#{horizon}")).where('date < ?', DateTime.current.to_date.send("end_of_#{horizon}"))
      end
    end
    @goals = goals_scope(@horizon, @term)
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
    def related_goal(horizon)
      if horizon == "week"
        related_horizon = "quarter"
      elsif horizon == "quarter"
        related_horizon = "year"
      elsif horizon == "year"
        related_horizon = "life"
      end
      if horizon == "week" || horizon == "quarter"
        Goal.where(horizon: related_horizon).where('date >= ?', DateTime.current.to_date.send("beginning_of_#{related_horizon}"))
      elsif
        Goal.where(horizon: related_horizon)
      end
    end
    @related_goal = []
    if related_goal(@horizon).present?
      @related_goal = related_goal(@horizon)
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
    if Goal.where(related_goal_id: params[:id]).present?
      @children_goals = Goal.where(related_goal_id: params[:id])
      @children_goals.each do |children_goal|
        children_goal[:related_goal_id] = nil
        children_goal.save
      end
    end
    @goal.destroy
    redirect_to action: "index", horizon: @goal[:horizon]
  end

  def edit_multiple
    @horizon = params[:horizon]
    @goal = Goal.find(params[:goal_ids])
    if @horizon == "week"
      @related_goal = Goal.where(horizon: "quarter")
      @related_goal_name = "quarter"
    elsif @horizon == "quarter"
      @related_goal = Goal.where(horizon: "year")
      @related_goal_name = "year"
    elsif @horizon == "year"
      @related_goal = Goal.where(horizon: "life")
      @related_goal_name = "life"
    end
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
