class News < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  validates_presence_of :title, :description, :content

  has_attached_file :image, :styles => {:medium => "300x300>", :icon => "110x110>" }, :whiny => false # allow non-image uploads

  scope :published, lambda {where("published_at IS NOT NULL")}

  attr_accessor :custom_published_at

  def publish
    update_attributes(published_at: Time.now)
  end

  def unpublish
    update_attributes(published_at: nil)
  end

end
