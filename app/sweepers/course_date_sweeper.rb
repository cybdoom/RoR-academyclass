class CourseDateSweeper < ApplicationSweeper
  observe CourseDate
  
  def after_save(course_date)
    expire_cache(course_date)
  end
  
  def after_destroy(course_date)
    expire_cache(course_date)
  end
  
  def expire_cache(course_date)
    course_date.course.products.each do |p|
      expire_page p.url
    end
    expire_xml_pages
  end
end
