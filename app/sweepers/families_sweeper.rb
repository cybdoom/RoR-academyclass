class FamiliesSweeper < ApplicationSweeper
  observe Family
  
  def after_save(family)
    expire_cache(family)
  end
  
  def after_destroy(family)
    expire_cache(family)
  end
  
  def expire_cache(family)
    expire_page root_path
    Family.all.each {|family| expire_page family_path(:id => family.slug)}
  end
end
