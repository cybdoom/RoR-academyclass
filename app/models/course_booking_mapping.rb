class CourseBookingMapping < ActiveRecord::Base
  belongs_to :video_product
  validates_uniqueness_of :course_name
end