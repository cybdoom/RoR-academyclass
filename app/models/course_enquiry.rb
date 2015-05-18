class CourseEnquiry < EmailLog
  attr_accessible :name, :email, :phone, :location, :enquiry, :date, :course_id, :opt_in, :link
  validates_presence_of :course_id
  belongs_to :course
  before_validation :set_subject, :on => :create
  after_create :send_response_email
  
  def set_subject
    self.subject = course.name
  end

  def opt_in=(value)
    super !value.blank?
  end
  
  def send_response_email
    SiteMailer.course_enquiry_response_email(self).deliver
  end

  def deliver_email
    SiteMailer.enquiry_email(self, sales_contact.to_s).deliver
  end
end
