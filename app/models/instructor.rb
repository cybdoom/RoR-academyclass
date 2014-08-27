class Instructor < ActiveRecord::Base
  default_scope :order => 'priority ASC'
  validates_presence_of :name, :staff_type
  before_validation :set_priority, :on => :create
  has_attached_file :avatar
  
  INSTRUCTOR = 1
  OFFICE_STAFF = 2
  
  def set_priority
    last = Instructor.last
    self.priority = last ? last.priority + 1 : 1
  end
  
  def instructor?
    return staff_type == INSTRUCTOR
  end
  
  def office_staff?
    return staff_type == OFFICE_STAFF
  end
  
  def image_path
    return "/images/instructors/#{image_name}"
  end
  
  def self.staff_types
    [["Instructor", INSTRUCTOR], ["Office Staff", OFFICE_STAFF]]
  end
  
  def type_name
    case staff_type
    when INSTRUCTOR then return "Instructor"
    when OFFICE_STAFF then return "Office Staff"
    else return "Unknown"
    end
  end
end