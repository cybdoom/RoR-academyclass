class VideosController < ApplicationController
  before_filter :check_trainer_access, :except => [:home, :show, :tagged]
  after_filter :mark_viewed, :only => [:home, :show, :tagged]
  cache_sweeper :video_sweeper, :only => [:create, :update, :destroy]

  layout "admin"
  helper_method :has_permission?
    
  def index
    @letter = params[:letter] || "A"
    @videos = Video.starting_with(@letter).includes(:video_products).order(:title).paginate(:page => params[:page], :per_page => 50)
  end
  
  def home
    render :layout => "videos"
  end
  
  def show
    @product = VideoProduct.find_by_slug(params[:product])
    @playlist = @product.videos.includes(:video_products)
    @video = params[:id] ? Video.find(params[:id]) : @playlist.select {|v| has_permission?(v, current_user)}.first || @playlist.first
    render :layout => "videos"
  end
  
  def tagged
    @tag_type = VideoTagType.find_by_category_and_slug(params[:category], params[:tag])
    @playlist = @tag_type.videos.includes(:video_products)
    @video = params[:id] ? Video.find(params[:id]) : @playlist.select {|v| has_permission?(v, current_user)}.first || @playlist.first
    render :layout => "videos"
  end
  
  def download_details
    @video = Video.new(params[:video])
    @video.download_details
    render :json => @video
  end
  
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(params[:video])
    if @video.save
      flash[:success] = "Video created successfully"
      redirect_to videos_path
    else
      render "new"
    end
  end
  
  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])
    @video.attributes = params[:video]
    if @video.save
      flash[:success] = "Video saved successfully"
      redirect_to videos_path
    else
      render "edit"
    end
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    render :nothing => true
  end
  
  def has_permission?(video, user)
    @has_permission ||= video && video.user_has_video_access?(user)
  end

  private
  def mark_viewed
    VideoView.create(:video => @video, :user => current_user) if @video && current_user && has_permission?(@video, current_user)
  end

end