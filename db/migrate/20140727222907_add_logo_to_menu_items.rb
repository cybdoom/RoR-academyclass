class AddLogoToMenuItems < ActiveRecord::Migration
  def up
    add_attachment :menu_items, :logo
  end
  
  def down
    remove_attachment :menu_items, :logo
  end
end
