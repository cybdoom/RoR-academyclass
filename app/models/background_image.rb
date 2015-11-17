class BackgroundImage < ActiveRecord::Base
  attr_accessible :link, :title, :image
  has_attached_file :image, :styles => {:medium => "300x300>", :icon => "110x110>", :large => "710>x" }, :whiny => false # allow non-image uploads
end
