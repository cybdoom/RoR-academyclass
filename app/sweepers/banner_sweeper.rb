class BannerSweeper < ApplicationSweeper
  observe Banner
  
  def after_save(banner)
    expire_cache(banner)
  end
  
  def after_destroy(banner)
    expire_cache(banner)
  end
  
  def expire_cache(banner)
    expire_all_pages
  end
end