class InstructorsSweeper < ApplicationSweeper
  observe Instructor
  
  def after_save(instructor)
    expire_all_pages
  end
  
  def after_destroy(instructor)
    expire_all_pages
  end
end
