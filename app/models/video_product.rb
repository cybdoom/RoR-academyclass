class VideoProduct < ActiveRecord::Base
  has_many :video_product_members, :order => :sequence, :dependent => :destroy
  has_many :videos, :through => :video_product_members, :order => :sequence
  has_many :course_booking_mapping, :dependent => :destroy
  belongs_to :first_video, :class_name => "Video"
  validates_presence_of :name, :slug
  
  has_attached_file :video_icon, :styles => {:normal => "150x100"}
  
  accepts_nested_attributes_for :video_product_members
  
  scope :not_free, where(:free => nil)
  
  def copy_members_to(video_product_id)
    UserVideoProduct.where(:video_product_id => id).each {|uvp| UserVideoProduct.create({:video_product_id => video_product_id, :user_id => uvp.user_id})}
  end
end