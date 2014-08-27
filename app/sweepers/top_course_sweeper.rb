class TopCourseSweeper < ApplicationSweeper
  observe TopCourse
  
  def after_save(course)
    expire_cache(course)
  end
  
  def after_destroy(course)
    expire_cache(course)
  end
  
  def expire_cache(course)
    expire_all_pages
  end
end
