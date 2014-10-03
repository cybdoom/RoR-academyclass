class SidebarItemSweeper < ApplicationSweeper
  observe SidebarItem
  
  def after_save(sidebar_item)
    expire_cache(sidebar_item)
  end
  
  def after_destroy(sidebar_item)
    expire_cache(sidebar_item)
  end
  
  def expire_cache(sidebar_item)
    expire_all_pages
  end
end
