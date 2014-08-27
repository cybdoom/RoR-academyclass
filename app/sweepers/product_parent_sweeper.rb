class ProductParentSweeper < ApplicationSweeper
  observe ProductParent
  
  def after_save(p)
    expire_cache(p)
  end
  
  def after_destroy(p)
    expire_cache(p)
  end
  
  def expire_cache(p)
    expire_all_pages
  end
end
