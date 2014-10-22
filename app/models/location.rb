class Location < ActiveRecord::Base

  scope :ordered, order(:id)

  has_attached_file :image, :styles => {:normal => "100x75"}, :default_style => :normal, :whiny => false # allow non-image uploads
  
  def self.GCODE
    "ABQIAAAAn5I9SCqf9euA-mJEurvEHhRdPFx3DPdRc7UaLDxhMTO2mBCgyxQm1bErpf-FJfGVJc9UojHPmdAgUg"
  end
  
  def coordinates
    return "#{longitude},#{latitude}"
  end
  
  def postcode
    return address.split(/\n/)[-1]
  end
  
  def postcode_town
    return postcode.match(/^([A-Z]{1,2})/)[1]
  end

  def has_coordinates?
    !longitude.blank? && !latitude.blank?
  end
  
  def self.find_locations_by_course
    locations = {}
    CourseDate.all(:conditions => "start_date > now()", :include => :location).each do |cd|
      locations[cd.course_id] ||= []
      locations[cd.course_id] << cd.location unless locations[cd.course_id].include?(cd.location)
    end
    locations
  end
end
