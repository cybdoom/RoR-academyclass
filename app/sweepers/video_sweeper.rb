class VideoSweeper < ApplicationSweeper
  observe Video
  
  def after_save(v)
    expire_cache(v)
  end
  
  def after_destroy(v)
    expire_cache(v)
  end
  
  def expire_cache(v)
    expire_fragment("video-show-#{v.id}")
    expire_fragment("video-tagged-#{v.id}")
    expire_fragment("video-home")
  end
end
