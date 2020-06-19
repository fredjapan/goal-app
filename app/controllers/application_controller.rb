class ApplicationController < ActionController::Base

  before_action :set_last_seen_at, if: proc { logged_in? }
  before_action :authorized
  helper_method :current_user
  helper_method :logged_in?

  def current_user    
    User.find_by(id: session[:user_id])  
  end

  def logged_in?     
    !current_user.nil?  
  end

  def authorized
    redirect_to '/welcome' unless logged_in?
  end

  private

  def set_last_seen_at
    current_user.update_attribute(:last_seen_at, Time.current)
  end

end
