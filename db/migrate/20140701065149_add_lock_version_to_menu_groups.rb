class AddLockVersionToMenuGroups < ActiveRecord::Migration
  def change
    add_column :menu_groups, :lock_version, :integer, default: 0, null: false
  end
end
