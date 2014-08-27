class TestimonialsSweeper < ActionController::Caching::Sweeper
  observe Testimonial
  
  def after_save(testimonial)
    expire_page what_clients_say_path
  end
  
  def after_destroy(testimonial)
    expire_page what_clients_say_path
  end
end
