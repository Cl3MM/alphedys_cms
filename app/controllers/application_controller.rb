class ApplicationController < ActionController::Base
  protect_from_forgery
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to login_url, :alert => "Not authorized" if current_user.nil?
  end

  def logged_in?
    current_user unless current_user.nil?
  end
  helper_method :logged_in?

  def authorize_if_admin
    redirect_to root_url, :alert => "Not authorized" if current_user.nil? or not current_user.is_admin?
  end
#  rescue_from CanCan::AccessDenied do |exception|
#  flash[:error] = "Access denied."
#  redirect_to root_url
#end
end
