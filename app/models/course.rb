class Course < ActiveRecord::Base
  has_attached_file :logo, :styles => { :tiny => "38x38>", :medium => "100x100>" }
  has_attached_file :palette_image
  has_many :course_products, :dependent => :destroy
  has_many :course_dates, :order => :start_date, :dependent => :destroy
  has_many :products, :through => :course_products, :order => "priority"
#  has_and_belongs_to_many :products#, :join_table => "course_products"
  has_many :outlines
  belongs_to :course_template
  has_one :sales_courses_list
  validates_presence_of :name
  validates_numericality_of :duration, :only_integer => true
#  validates_numericality_of :cost
  before_validation :clean_data

  scope :ordered, order(:name)
  scope :published, where("publish_xml=1")
  scope :with_locations, includes(course_dates: :location)
  scope :for_product_page, lambda {|product_id| joins(:course_products).includes(:course_dates).where("product_id=?", product_id).order("priority")}

  def self.matching_letter(letter)
    letter = letter == "0-9" ? '[[:digit:]]+' : letter[0,1]
    Course.where("name REGEXP ?", "^#{letter}").order(:name)
  end
  
  def clean_data
    self.name = name.strip
    self.what_you_get = nil unless course_template.nil?
  end
  
  def what_you_get_copy
    course_template_id.nil? ? what_you_get : course_template.copy
  end

  def url
    return "#{products.first.url}##{anchor}"
  end
  
  def anchor
    return name.gsub(/[ ]/, "-").gsub(/\&/, "and")
  end

  def outlines_array
    o = outlines
    half = (o.size / 2).ceil
    return [o.slice(0,half),o.slice(half,half+1)]
  end
  
  def has_future_dates?
    today = Date.today
    course_dates.select {|cd| cd.start_date > today}.length > 0
  end
  
  def locations_and_dates
    # e.g. [city => [month => [dates], month => [dates]]]
    course_dates_array = []
    course_dates_array << {"" => Hash.new { |hash, key| hash[key] = [] }}
    Location.all.each do |location|
      months = Hash.new { |hash, key| hash[key] = [] }
      CourseDate.all(:select => "start_date, end_date",:conditions => ["location_id = ? AND course_id = ? AND start_date >= ?", location.id, id, Date.today]).each do |cd|
        months[cd.start_date.strftime("%b")] << "#{cd.start_date.day} - #{cd.end_date.day}"
      end
      course_dates_array << {location.name => months}
    end
    course_dates_array
    # locations.map {|location| location.name}
  end
end
