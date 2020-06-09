class GoalsController < ApplicationController

  def index
    @horizon = params[:horizon]
    @term = params[:term]
    def goals_scope(horizon, term)
      if term == "term_previous"
        Goal.where(user: current_user).where(horizon: horizon).where('date < ?', DateTime.current.to_date.send("beginning_of_#{horizon}"))
      elsif term == "term_next"
        Goal.where(user: current_user).where(horizon: horizon).where('date > ?', DateTime.current.to_date.send("end_of_#{horizon}"))
      else
        Goal.where(user: current_user).where(horizon: horizon).where('date >= ?', DateTime.current.to_date.send("beginning_of_#{horizon}")).where('date <= ?', DateTime.current.to_date.send("end_of_#{horizon}"))
      end
    end
    @goals = goals_scope(@horizon, @term)
    @allgoals = Goal.all.where(user: current_user)
    @lifegoals = LifeGoal.all.where(user: current_user)
  end
  
  def show
    @horizon = params[:horizon]
    @term = params[:term]
    id = params[:id]
    @goal = Goal.find(id)
    @parent_goal = parent_goal(@goal.parent_goal_id, @horizon)
    respond_to do |format|
      format.js
    end
  end

  def new
    @horizon = params[:horizon]
    @goal = Goal.new
    @parent_goals = []
    if parent_goals(@horizon, "term_this").where(user: current_user).present?
      @parent_goals = parent_goals(@horizon, "term_this").where(user: current_user)
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
    @parent_goals = []
    if parent_goals(@horizon, @term).where(user: current_user).present?
      @parent_goals = parent_goals(@horizon, @term).where(user: current_user)
    end
    respond_to do |format|
      format.js
    end
  end

  def create
    @horizon = params[:horizon]
    @term = params[:term]
    @goal = Goal.new(goal_params.merge(user: current_user))
    if @goal.save
      render js: "window.location='#{goals_path(horizon: @horizon, term:
        if @goal.date >= DateTime.current.to_date.send("beginning_of_#{@horizon}") && @goal.date <= DateTime.current.to_date.send("end_of_#{@horizon}")
          "term_this"
        elsif @goal.date >= helpers.next_term(@horizon).from_now.to_date.send("beginning_of_#{@horizon}") && @goal.date <= helpers.next_term(@horizon).from_now.to_date.send("end_of_#{@horizon}")
          "term_next"
        end
      )}'"
    else
      respond_to do |format|
        format.js 
      end
    end
  end

  def update
    @horizon = params[:horizon]
    @term = params[:term]
    id = params[:id]
    @goal = Goal.find(id)
    if @goal.update(goal_params)
      render js: "window.location='#{goals_path(horizon: @horizon, term: 
        if @goal.date >= DateTime.current.to_date.send("beginning_of_#{@horizon}") && @goal.date <= DateTime.current.to_date.send("end_of_#{@horizon}")
          "term_this"
        elsif @goal.date >= helpers.next_term(@horizon).from_now.to_date.send("beginning_of_#{@horizon}") && @goal.date <= helpers.next_term(@horizon).from_now.to_date.send("end_of_#{@horizon}")
          "term_next"
        elsif @goal.date < DateTime.current.to_date.send("beginning_of_#{@horizon}")
          "term_previous"
        end
      )}'"
    else
      respond_to do |format|
        format.js 
      end
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    if Goal.where(parent_goal_id: params[:id]).where.not(horizon: "year").present?
      @children_goals = Goal.where(parent_goal_id: params[:id]).where.not(horizon: "year")
      @children_goals.each do |children_goal|
        children_goal[:parent_goal_id] = nil
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
    @parent_horizon = parent_horizon(@horizon)
    @parent_goals = parent_goals(@horizon, "term_previous").where(user: current_user)
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
    params.require(:goal).permit(:title, :description, :achievement, :date, :horizon, :parent_goal_id, :term)
  end

  def parent_horizon(horizon)
    if horizon == "week"
      "quarter"
    elsif horizon == "quarter"
      "year"
    elsif horizon == "year"
      "life"
    end
  end

  def parent_goals(horizon, term)
    if horizon == "week" || horizon == "quarter"
      if term == "term_previous"
        Goal.where(horizon: parent_horizon(horizon))
      elsif term == "term_this" || term == "term_next"
        Goal.where(horizon: parent_horizon(horizon)).where('date >= ?', DateTime.current.to_date.send("beginning_of_#{parent_horizon(horizon)}"))
      end
    elsif horizon == "year"
      LifeGoal.all
    end
  end

  def parent_goal(parent_goal_id, horizon)
    if parent_goal_id.present?
      if horizon == "week" ||  horizon == "quarter"
        Goal.find(parent_goal_id)
      elsif @horizon == "year"
        LifeGoal.find(parent_goal_id)
      end
    else
      ""
    end
  end

  def parent_horizon_start(horizon)
    DateTime.current.to_date.send("beginning_of_#{parent_horizon(horizon)}")
  end
  
end
