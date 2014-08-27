class VideoTagTypesController < ApplicationController
  before_filter :check_trainer_access
  cache_sweeper :video_tag_types_sweeper, :only => [:create, :update, :destroy]  
  layout "admin"
  
  def index
    @types = VideoTagType.order(:name).all
  end
  
  def new
    @type = VideoTagType.new(:category => params[:category])
  end
  
  def create
    @type = VideoTagType.new(params[:video_tag_type])
    if @type.save
      flash[:success] = "#{@type.name} created successfully"
      redirect_to video_tag_types_path
    else
      render "new"
    end
  end

  def show
    @type = VideoTagType.includes(:video_tags => :video).find(params[:id])
  end
  
  def edit
    @type = VideoTagType.find(params[:id])
  end

  def sort
    params[:tag].each_with_index do |id,i|
      tag = VideoTag.find(id)
      tag.sequence = i+1
      tag.save
    end
    render :nothing => true
  end
  
  def update
    @type = VideoTagType.find(params[:id])
    @type.attributes = params[:video_tag_type]
    success = @type.save
    respond_to do |r|
      r.html do
        if success
          redirect_to video_tag_types_path
        else
          render "edit"
        end
      end
      r.js { render :nothing => true }
    end
  end
end