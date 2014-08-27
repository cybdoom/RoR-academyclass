class ProductParent < ActiveRecord::Base
#  default_scope :order => :name
  has_many :products, :order => 'products.name', :dependent => :destroy
  has_attached_file :parent_image
  validates_presence_of :name
  validates_uniqueness_of :name
  before_validation {|p| p.name = p.name.strip}

  scope :with_courses, includes(:products => :courses)
  scope :with_dates_and_locations, includes({:products => {:courses => {:course_dates => :location}}})
  scope :after_today, where("course_dates.start_date > now()")

  
  def url
    return "/training/#{encode_name}"
  end

  def encode_name
    return "" if name.blank?
    return name.gsub(/&/, "and").gsub(/ /, "-")
  end
end
