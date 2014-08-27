class BookingDelegate < ActiveRecord::Base
  belongs_to :booking_form

  scope :from_completed_bookings, joins(:booking_form).where("booking_forms.status=?", BookingForm::COMPLETED)
  scope :has_email, where("booking_delegates.email IS NOT NULL")
  
  def matches?(hash)
    name == hash['name'] && 
    course_name == hash['course_name'] &&
    course_location == hash['course_location'] &&
    start_date.strftime('%Y-%m-%d') == hash['start_date'] &&
    end_date.strftime('%Y-%m-%d') == hash['end_date'] &&
    platform_pc == (hash['platform_pc'] == "1") &&
    price.to_f == hash['price'].to_f &&
    booking_type == hash['booking_type'] &&
    email == hash['email']
  end
  
  def onsite?
    course_location == 'On-site'
  end
  
  def self.create_users
    BookingDelegate.from_completed_bookings.has_email.where("booking_delegates.start_date=?", Date.today).each do |d|
      user = User.find_by_username(d.email).nil?
      if user
        d.create_user
      else
        d.add_videos_to_user(user)
      end
    end
  end
  
  def create_user
    video_product_ids = find_and_create_video_product_mappings
    return if video_product_ids.empty?
    pw = User.generate_password
    user = User.new(:username => email, :email => email, :name => name, :user_type => User::DELEGATE, :password => pw, :password_confirmation => pw)
    user.video_product_ids = video_product_ids
    
    SiteMailer.new_user_email(user).deliver if user.save
  end
  
  def add_videos_to_user(user)
    video_product_ids = find_and_create_video_product_mappings
    video_product_ids.each do |id|
      user.video_product_ids << id unless user.video_product_ids.include?(id)
    end
    user.save
    SiteMailer.video_access_email(user).deliver
  end
  
  def find_and_create_video_product_mappings
    # find the names of all courses this delegate is attending
    course_names = BookingDelegate.from_completed_bookings.where("booking_delegates.email=?", email).uniq.pluck(:course_name)
    
    # find the mappings of the course names to video products
    mappings = {}
    CourseBookingMapping.where(:course_name => course_names).each {|m| mappings[m.course_name] = m.video_product_id }
    
    # create any mappings which don't already exist
    course_names.each {|name| CourseBookingMapping.create({:course_name => name}) unless mappings.has_key?(name) }
    
    # return all the mappings which do exist (the video product IDs)
    mappings.values.uniq.compact
  end
end