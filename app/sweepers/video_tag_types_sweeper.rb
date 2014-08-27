class VideoTagTypesSweeper < ApplicationSweeper
  observe VideoTagType
  
  def after_save(vtt)
    expire_cache
  end
  
  def after_destroy(vtt)
    expire_cache
  end
  
  def expire_cache
    expire_fragment('videos_menu')
  end
end
