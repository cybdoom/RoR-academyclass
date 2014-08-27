class CourseDetailEnquiry < EmailLog
  # Created when someone clicks the "email me the details" link
  attr_accessible :name, :email, :course
  validates_presence_of :course
  after_create :deliver_email

  def course=(id)
    unless id.blank?
      @course = Course.find(id)
      self.subject = @course.name
    end
  end
  
  def course
    @course.id unless @course.nil?
  end
  
  def recipient_email
    email
  end
  
  def deliver_email
    SiteMailer.course_email(@course, name, email).deliver
  end
end