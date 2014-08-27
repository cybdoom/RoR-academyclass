class BannersController < ApplicationController
  before_filter :check_admin
  cache_sweeper :banner_sweeper, :only => [:create, :update, :destroy]
  layout "admin"
  
  def index
    @banners = Banner.all(:order => "position")
  end
  
  def new
    @banner = Banner.new
  end
  
  def create
    @banner = Banner.new(params[:banner])
    if @banner.save
      redirect_to banners_path
    else
      render :new
    end
  end
  
  def edit
    @banner = Banner.find(params[:id])
  end
  
  def update
    @banner = Banner.find(params[:id])
    @banner.attributes = params[:banner]
    if @banner.save
      redirect_to banners_path
    else
      render :edit
    end
  end
  
  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy
    redirect_to banners_path
  end
end
