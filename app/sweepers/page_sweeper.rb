class PageSweeper < ApplicationSweeper
  observe Page
  
  def after_save(page)
    expire_cache(page)
  end
  
  def expire_cache(page)
    case page.name
    when "training" then expire_page training_path
    when "creative licence" then expire_page save_path
    when "terms and conditions" then expire_page :controller => :cms, :action => :terms_and_conditions
    when "terms of business" then expire_page :controller => :cms, :action => :terms_of_business
    when "privacy policy" then expire_page :controller => :cms, :action => :privacy_policy
    else expire_page root_path
    end
  end
end
