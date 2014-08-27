module VideosHelper
  
  def full_video_path(video, product = nil)
    unless product
      product = @product ? @product : video.video_products.first
      product = VideoProduct.first unless product
    end
    if @tag_type
      related_video_path(video.id, :slug => slugify(video.title), :category => @tag_type.category, :tag => @tag_type.slug)
    else
      play_video_path(video.id, :product => product.slug, :slug => slugify(video.title))
    end
  end
  
  def video_thumbnail_class(video)
    (video.user_has_video_access?(current_user) ? '' : 'member-only') + (video_viewed_by?(video, current_user) ? " viewed" : '')
  end

  def video_viewed_by?(video, user)
    return false unless user
    @video_views ||= VideoView.where({:user_id => user.id}).pluck(:video_id).uniq
    @video_views.include?(video.id)
  end  

  def user_group_video_tags
    lookup_video_tag_types unless @user_groups
    @user_groups
  end

  def staff_picks_video_tags
    lookup_video_tag_types unless @staff_picks
    @staff_picks
  end

  def lookup_video_tag_types
    tag_types = VideoTagType.all
    @user_groups = []
    @staff_picks = []
    tag_types.each do |t|
      @staff_picks << t if t.category == VideoTagType::STAFF_PICK
      @user_groups << t if t.category == VideoTagType::USER_GROUP
    end
  end

  def featured_videos
    @featured ||= VideoFeature.for_linking
  end

  def video_cache_id
    return "video-home" if params[:action] == "home"
    if has_permission?(@video, current_user)
      return "video-#{params[:action]}-#{@video.id}"
    elsif @video
      return "video-permission-denied"
    else
      return "video-not-found"
    end
  end
end