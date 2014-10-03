class ChangeOrderNumToPositionForSidebarItems < ActiveRecord::Migration
  def change
    rename_column :sidebar_items, :order_num, :position
  end
end
