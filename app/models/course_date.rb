class CourseDate < ActiveRecord::Base
  belongs_to :course
  belongs_to :location
  belongs_to :trainer
  default_scope :order => :start_date
  validates_presence_of :location, :start_date, :end_date
  validate :valid_dates

  scope :future, where('start_date > now()')
  scope :find_all_by_product_id, lambda {|product_id| joins(course: :course_products).where("course_products.product_id=?", product_id)}

  def valid_dates
    if start_date && end_date
      errors.add(:end_date, "Must be after the start date") if start_date > end_date
      errors.add(:start_date, "Is too high") if start_date > Date.new(2020,1,1)
      errors.add(:start_date, "Is too low") if start_date < Date.new(2006,1,1)
      errors.add(:end_date, "Is too high") if end_date > Date.new(2020,1,1)
      errors.add(:end_date, "Is too low") if end_date < Date.new(2006,1,1)
    end
  end  
  
  def current?
    return start_date > Date.today
  end
  
  def seats_available
    return nil unless total_seats && seats_sold
    total_seats - seats_sold
  end
  
  def self.find_by_course_location_date(course_name, location, date)
    pattern = course_name.gsub(/[^a-zA-Z0-9]/, "%")
    CourseDate.joins(:course, :location)\
      .where("courses.name LIKE ? AND locations.name=? AND start_date <= ? AND end_date >= ?", pattern, location, date, date).first
  end
end