class ApplicationSweeper < ActionController::Caching::Sweeper
  
  def expire_all_pages
    expire_html_pages
    expire_xml_pages
  end
  
  def expire_html_pages
    ["index", "consultancy", "creative_services", "locations", "aboutus", "training", "private_training", "evenings_and_weekends", "what_clients_say", "meet_the_instructors", "certifications", "terms_and_conditions", "privacy_policy", "terms_of_business", "sitemap", "save"].each do |action|
      expire_page :controller => :cms, :action => action
    end
    expire_page :controller => :contact, :action => :index
    expire_all_course_pages
    Family.all.each {|family| expire_page family_path(:id => family.slug)}
  end

  def expire_all_course_pages
    ProductParent.all(:include => {:products => :product_parent}).each do |pp|
      expire_page pp.url
      pp.products.each {|p| expire_page p.url }
    end
  end
  
  def expire_xml_pages
    expire_page xml_courses_path
    expire_page xml_course_dates_path
    expire_page xml_courses_with_dates_path
    expire_page xml_learn_pipe_path
    expire_page xml_courses_plus_path
  end
end