class Trainer < ActiveRecord::Base
  has_many :course_dates
  validates_presence_of :name
  validates_uniqueness_of :name
end
