class UsersController < ApplicationController
  before_filter :check_backend_access
  before_filter :find_and_check_user_permission, :only => [:edit, :update, :destroy]
  layout "admin"
  
  def index
    @user_type = (params[:user_type] || 0).to_i
    @users = User.find_by_type(@user_type).paginate(:page => params[:page], :per_page => 50)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.user_type = User::DELEGATE unless current_user.admin?
    if @user.save
      flash[:success] = "User saved successfully"
      redirect_to users_path
    else
      flash[:error] = "Error saving user"
      render "new"
    end
  end
  
  def update
    @user.attributes = params[:user]
    @user.user_type = User::DELEGATE unless current_user.admin?
    if @user.save
      flash[:success] = "User saved succesfully"
      redirect_to users_path
    else
      render "edit"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end
  
  private
  def find_and_check_user_permission
    @user = User.find(params[:id])
    unless @user.delegate? || current_user.admin?
      flash[:error] = "You do not have permission to modify this user"
      redirect_to users_path
    end
  end
end
