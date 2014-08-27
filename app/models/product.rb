class Product < ActiveRecord::Base
  has_attached_file :product_logo, :styles => { :icon => "110x110>" }, :whiny => false # allow non-image uploads
  default_scope :order => 'products.name'
  belongs_to :product_parent
  has_many :course_products, :dependent => :destroy
#  has_and_belongs_to_many :courses#, :join_table => "course_products", :order => "priority"
  has_many :courses, :through => :course_products, :order => "course_products.priority"
  has_many :product_families, :dependent => :destroy
  has_many :families, :through => :product_families
  has_one :footer_link, :dependent => :destroy
  validates_presence_of :product_parent, :name
  validates_uniqueness_of :name
  before_validation {|p| p.name = p.name.strip}
  
  def <=>(o)
    return name <=> o.name
  end
  
  def url
    return "/training/#{self.product_parent.encode_name}/#{encode_name}-training-course"
  end

  def encode_name
    return "" if name.blank?
    return name.gsub(/ /, "-")#.gsub(/\//, "%2F")
  end

  def has_course_with_future_dates?
    courses.select {|c| c.has_future_dates? }.length > 0
  end

  def set_courses(courses)
    courses.each_index do |i|
      c = courses[i]
      update_or_create_course(c.to_i, i+1)
    end
    self.course_products.each do |cp|
      cp.destroy unless courses.include?(cp.course_id.to_s)
    end
    save # called only to invoke the cache sweeper
  end
  
  private
  def update_or_create_course(course_id, priority)
    self.course_products.each do |cp|
      if course_id == cp.course_id
        cp.priority = priority
        cp.save
        return
      end
    end
    self.course_products << CourseProduct.new({:course_id => course_id, :priority => priority})
  end
end
