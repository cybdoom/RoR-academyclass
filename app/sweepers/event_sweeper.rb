class EventSweeper < ActionController::Caching::Sweeper
  observe Event
  
  def after_save(event)
    expire_cache(event)
  end
  
  def after_destroy(event)
    expire_cache(event)
  end
  
  def expire_cache(event)
    expire_page :controller => :events, :action => :index
    expire_page :controller => :events, :action => :show  
    expire_page :controller => :cms, :action => :sitemap
    expire_page :controller => :cms, :action => :sitemap, :format => :js
  end
end
