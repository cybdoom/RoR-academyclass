class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  helper_method :current_user
  
  def rescue_action_without_handler(exception)
    if exception.class.to_s == "ActionController::RoutingError"
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    else
      super
    end
  end
  
  protected
  def current_user
    return @current_user if @current_user
    session = UserSession.find
    @current_user = session.user if session
    @current_user
  end
  
  def check_backend_access
    check_access_or_redirect(:backend_access?)
  end
  
  def check_admin
    check_access_or_redirect(:admin?)
  end
  
  def check_sales_access
    check_access_or_redirect(:sales?)
  end
  
  def check_trainer_access
    check_access_or_redirect(:trainer?)
  end
  
  def check_logged_on
    redirect_to :controller => :user_sessions, :action => :new unless current_user
    return !current_user.nil?
  end

  # for API methods - validate the username and password
  def check_user_parameters
    @user = User.find_by_username(params[:username])
    render :status => 500, :text => "Invalid username or password" if @user.nil? || @user.crypted_password != params[:password]
  end
  
  def worldpay_url
    Rails.env.production? ? "https://select.worldpay.com/wcc/purchase/" : "https://select-test.worldpay.com/wcc/purchase/"
  end

  private
  def check_access_or_redirect(method)
    return true if current_user && (current_user.admin? || current_user.send(method))
    flash[:error] = "You do not have permission to access this page"
    redirect_to login_path
    false
  end
end
