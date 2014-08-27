class CourseProduct < ActiveRecord::Base
  belongs_to :course
  belongs_to :product
  default_scope :order => "priority"
end