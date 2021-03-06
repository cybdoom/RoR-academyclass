class ProductSweeper < ApplicationSweeper
  observe Product
  
  def after_save(product)
    expire_cache(product)
  end
  
  def after_destroy(product)
    expire_cache(product)
  end
  
  def expire_cache(product)
    expire_all_pages
  end
end
