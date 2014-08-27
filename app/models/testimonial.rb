class Testimonial < ActiveRecord::Base
  acts_as_list
  has_attached_file :photo, :styles => {:icon => "50x50", :normal => "180x180"}
  has_attached_file :case_study
end