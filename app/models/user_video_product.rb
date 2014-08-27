class UserVideoProduct < ActiveRecord::Base
  belongs_to :user
  belongs_to :video_product
  
  #validates_presence_of :user_id, :video_product_id
  validates_uniqueness_of :user_id, :scope => :video_product_id
end
