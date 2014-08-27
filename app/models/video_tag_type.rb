class VideoTagType < ActiveRecord::Base
  validates_presence_of :name, :slug, :category
  validates_uniqueness_of :name, :scope => :category
  validates_uniqueness_of :slug, :scope => :category
  
  has_many :video_tags, :order => :sequence
  has_many :videos, :through => :video_tags, :order => :sequence

  accepts_nested_attributes_for :video_tags
  
  INSTRUCTOR = "Instructor"
  USER_GROUP = "User Group"
  STAFF_PICK = "Staff Pick"
end