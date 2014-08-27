class FooterLinkSweeper < ApplicationSweeper
  observe FooterLink
  
  def after_save(footer_link)
    expire_cache(footer_link)
  end
  
  def after_destroy(footer_link)
    expire_cache(footer_link)
  end
  
  def expire_cache(footer_link)
    expire_all_pages
  end
end
