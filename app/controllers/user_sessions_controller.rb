class UserSessionsController < ApplicationController
  layout "admin"
  
  def new
    return redirect_user_after_login(current_user) if current_user
    @session = UserSession.new
    respond_to do |r|
      r.js { render :layout => false }
      r.html
    end
  end
  
  def create
    @session = UserSession.new(params[:user_session])
    success = @session.save
    respond_to do |r|
      r.html do
        if success
          redirect_user_after_login(@session.user)
        else
          render :new
        end
      end
      r.js { render :json => @session }
    end
  end
  
  def destroy
    session = UserSession.find
    session.destroy if session
    redirect_to videos_home_path
  end
  
  def auth_callback
    user = UserAuthentication.find_or_create_user(request.env["omniauth.auth"])
    UserSession.new(user, true).save
    redirect_user_after_login(user)
  end
  
  def auth_failure
    render :layout => "application"
  end
  
  private
  def redirect_user_after_login(user)
    redirect_to case user.user_type
      when User::ADMIN then booking_forms_path
      when User::SALES then booking_forms_path
      when User::DELEGATE then videos_home_path
      when User::TRAINER then users_path
    end
  end
end
