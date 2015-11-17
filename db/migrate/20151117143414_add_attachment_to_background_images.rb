class AddAttachmentToBackgroundImages < ActiveRecord::Migration
  def up
    add_attachment :background_images, :image
  end

  def down
    remove_attachment :background_images, :image
  end
end
