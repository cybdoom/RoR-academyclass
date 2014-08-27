class RenameMenuItem < ActiveRecord::Migration
  def up
    if menu_item = MenuItem.where(label: 'Ajax').first
      menu_item.label = 'UX Design'
      menu_item.url = '/training/Web-Fundamentals/User-Experience-Design-(UX)-training-course'
      menu_item.save
    end
  end
end
