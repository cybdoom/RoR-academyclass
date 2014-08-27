class TopCourse < ActiveRecord::Base
  default_scope :order => :position
  acts_as_list
  belongs_to :course
  validates_presence_of :course
  validates_uniqueness_of :course_id

  scope :with_products, includes(:course => {:products => :product_parent})
  
  def display_name
    return name.blank? ? course.name : name
  end
end