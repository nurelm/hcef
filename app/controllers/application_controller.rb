class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, :with => :rescue_not_found

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_user 
      flash[:error] = "You are not authorized to take this action."
      redirect_to home_path
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def rescue_not_found
    render :file => "#{Rails.root}/public/404.html", :status => 404 
  end
end
