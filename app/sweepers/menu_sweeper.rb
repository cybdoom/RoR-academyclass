class MenuSweeper < ApplicationSweeper
  observe MenuGroup, MenuItem
  
  def after_save(menu)
    expire_fragment('menu')
    expire_html_pages
  end
  
  def after_destroy(course)
    expire_fragment('menu')
    expire_html_pages
  end
end
