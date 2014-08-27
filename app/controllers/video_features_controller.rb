class VideoFeaturesController < ApplicationController
  before_filter :check_admin
  cache_sweeper :video_feature_sweeper, :only => [:create, :destroy]
  layout "admin"
  
  def index
    @features = VideoFeature.includes(:video).order(:position)
  end
  
  def new
    @feature = VideoFeature.new
    render :layout => false
  end
  
  def create
    @feature = VideoFeature.new(params[:video_feature])
    @feature.save
    redirect_to video_features_path
  end
  
  def destroy
    f = VideoFeature.find(params[:id])
    f.destroy
    flash[:success] = "Success"
    redirect_to video_features_path
  end
end