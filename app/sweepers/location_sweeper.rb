class LocationSweeper < ApplicationSweeper
  observe Location
  
  def after_save(location)
    expire_cache(location)
  end
  
  def after_destroy(location)
    expire_cache(location)
  end
  
  def expire_cache(location)
    expire_page :controller => :locations, :action => :index
    expire_page :controller => :cms, :action => :contact
    expire_page :controller => :js, :action => :locations, :format => :js
    expire_xml_pages
    expire_all_course_pages
  end
end
