class UsersController < ApplicationController
  
  skip_before_action :authorized, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      horizons = ["year", "quarter", "week"]
      id = nil
      life_goal = LifeGoal.create(title: "A Musician", what: "Life feels like a dancing melody.", why: "Make life more harmonious.", user_id: @user.id)
      life_goal_id = life_goal.id
      horizons.each do |horizon|
        goal = Goal.create(title: "My first #{horizon}ly goal", description: "This is where you explain what this goal is about.", date: DateTime.current.to_date.send("end_of_#{horizon}"), horizon: "#{horizon}", user_id: @user.id, parent_goal_id: horizon != "year" ? id : life_goal_id)
        id = goal.id
      end
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
