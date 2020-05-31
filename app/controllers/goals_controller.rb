class GoalsController < ApplicationController

  def index
    @horizon = params[:horizon]
    @term = params[:term]
    if @horizon == "week"
      @related_horizon = "quarter"
    elsif @horizon == "quarter"
      @related_horizon = "year"
    elsif @horizon == "year"
      @related_horizon = "life"
    end
    def goals_scope(horizon, term)
      if term == "term_previous"
        Goal.where(horizon: horizon).where('date < ?', DateTime.current.to_date.send("beginning_of_#{horizon}"))
      elsif term == "term_next"
        Goal.where(horizon: horizon).where('date > ?', DateTime.current.to_date.send("end_of_#{horizon}"))
      else
        Goal.where(horizon: horizon).where('date >= ?', DateTime.current.to_date.send("beginning_of_#{horizon}")).where('date <= ?', DateTime.current.to_date.send("end_of_#{horizon}"))
      end
    end
    @goals = goals_scope(@horizon, @term)
    @allgoals = Goal.all
    @lifegoals = LifeGoal.all
  end
  
  def show
    @horizon = params[:horizon]
    @term = params[:term]
    id = params[:id]
    @goal = Goal.find(id)
    if @goal.related_goal_id.present?
      if @horizon == "week" ||  @horizon == "quarter"
        @parent_goal = Goal.find(@goal.related_goal_id)
      elsif @horizon == "year"
        @parent_goal = LifeGoal.find(@goal.related_goal_id)
      end
    else
      @parent_goal =""
    end
    respond_to do |format|
      format.js
    end
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
      elsif horizon == "year"
        LifeGoal.all
      end
    end
    @related_goal = []
    if related_goal(@horizon).present?
      @related_goal = related_goal(@horizon)
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    @horizon = params[:horizon]
    @term = params[:term]
    id = params[:id]
    @goal = Goal.find(id)
    def related_goal(horizon)
      if horizon == "week"
        related_horizon = "quarter"
      elsif horizon == "quarter"
        related_horizon = "year"
      elsif horizon == "year"
        related_horizon = "life"
      end
      if horizon == "week" || horizon == "quarter"
        if @term == "term_previous"
          Goal.where(horizon: related_horizon)
        elsif @term == "term_this" || "term_next"
          Goal.where(horizon: related_horizon).where('date >= ?', DateTime.current.to_date.send("beginning_of_#{related_horizon}"))
        end
      elsif horizon == "year"
        LifeGoal.all
      end
    end
    @related_goal = []
    if related_goal(@horizon).present?
      @related_goal = related_goal(@horizon)
    end
    respond_to do |format|
      format.js
    end
  end

  def create
    @horizon = params[:horizon]
    @term = params[:term]
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to action: "index", horizon: @goal[:horizon], term: 
        if @goal.date >= DateTime.current.to_date.send("beginning_of_#{@horizon}") && @goal.date <= DateTime.current.to_date.send("end_of_#{@horizon}")
          "term_this"
        elsif @goal.date >= helpers.next_term(@horizon).from_now.to_date.send("beginning_of_#{@horizon}") && @goal.date <= helpers.next_term(@horizon).from_now.to_date.send("end_of_#{@horizon}")
          "term_next"
        end
    else
      render 'new'
    end
  end

  def update
    @horizon = params[:horizon]
    @term = params[:term]
    id = params[:id]
    @goal = Goal.find(id)
    if @goal.update(goal_params)
      redirect_to action: "index", horizon: @goal[:horizon], term: 
      if @goal.date >= DateTime.current.to_date.send("beginning_of_#{@horizon}") && @goal.date <= DateTime.current.to_date.send("end_of_#{@horizon}")
        "term_this"
      elsif @goal.date >= helpers.next_term(@horizon).from_now.to_date.send("beginning_of_#{@horizon}") && @goal.date <= helpers.next_term(@horizon).from_now.to_date.send("end_of_#{@horizon}")
        "term_next"
      elsif @goal.date < DateTime.current.to_date.send("beginning_of_#{@horizon}")
        "term_previous"
      end
    else
      render 'edit'
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    if Goal.where(related_goal_id: params[:id]).where.not(horizon: "year").present?
      @children_goals = Goal.where(related_goal_id: params[:id]).where.not(horizon: "year")
      @children_goals.each do |children_goal|
        children_goal[:related_goal_id] = nil
        children_goal.save
      end
    end
    @goal.destroy
    redirect_to action: "index", horizon: @goal[:horizon], term: 
    if @goal.date >= DateTime.current.to_date.send("beginning_of_#{@goal[:horizon]}") && @goal.date <= DateTime.current.to_date.send("end_of_#{@goal[:horizon]}")
      "term_this"
    elsif @goal.date >= helpers.next_term(@goal[:horizon]).from_now.to_date.send("beginning_of_#{@goal[:horizon]}") && @goal.date <= helpers.next_term(@goal[:horizon]).from_now.to_date.send("end_of_#{@goal[:horizon]}")
      "term_next"
    elsif @goal.date < DateTime.current.to_date.send("beginning_of_#{@goal[:horizon]}")
      "term_previous"
    else
      "term_this"
    end
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
      @related_goal = LifeGoal.all
      @related_goal_name = "life"
    end
  end

  def update_multiple
    @horizon = params[:horizon]
    @term = params[:term]
    @goal = Goal.update(params[:goal].keys, params[:goal].values)
    redirect_to action: "index", horizon: @horizon, term: "term_this"
  end

  private
  # Using a private method to encapsulate the permissible parameters
  # is just a good pattern since you'll be able to reuse the same
  # permit list between create and update. Also, you can specialize
  # this method with per-user checking of permissible attributes.
  def goal_params
    params.require(:goal).permit(:title, :description, :achievement, :date, :horizon, :related_goal_id, :term)
  end
end
