class Outline < ActiveRecord::Base
  belongs_to :course
  has_many :bullets, :class_name => "OutlineBullet"
end
