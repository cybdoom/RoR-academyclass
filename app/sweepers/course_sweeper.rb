class CourseSweeper < ApplicationSweeper
  observe Course
  
  def after_save(course)
    expire_cache(course)
  end
  
  def after_destroy(course)
    expire_cache(course)
  end
  
  def expire_cache(course)
    course.products.each do |p|
      expire_page p.url
      #expire_page :controller => 'products', :action => 'show', :product_parent => p.product_parent.encode_name, :product => p.encode_name
    end
    expire_xml_pages
    expire_page course_path(course, :format => :pdf)
  end
end