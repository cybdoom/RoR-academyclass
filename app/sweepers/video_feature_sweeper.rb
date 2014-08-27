class VideoFeatureSweeper < ApplicationSweeper
  observe VideoFeature
  
  def after_save(v)
    expire_cache
  end
  
  def after_destroy(v)
    expire_cache
  end
  
  def expire_cache
    expire_fragment('featured-videos')
  end
end
