class SessionsController < ApplicationController
  
  skip_before_action :authorized, only: [:new, :create, :welcome]
  
  def new
    
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
       session[:user_id] = @user.id
       flash[:notice] = "Happy to see you again!"
       redirect_to root_path
    else
       redirect_to '/login'
       flash[:error] = "The combination email and password is incorrect."
    end
  end

  def login
  end

  def welcome
  end

  def destroy  
    session.delete(:user_id)
    flash[:notice] = "You have successfully logged out."
    redirect_to '/welcome'
  end

  def page_requires_login

  end

end
