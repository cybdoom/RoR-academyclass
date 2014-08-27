class AddOpenInNewWindowToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :open_in_new_window, :boolean, null: false, default: false
  end
end
