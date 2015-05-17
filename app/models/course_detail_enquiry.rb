class CourseDetailEnquiry < EmailLog
  # Created when someone clicks the "email me the details" link
  attr_accessible :name, :email, :course_id, :link
  belongs_to :course
  validates_presence_of :course_id
  before_validation :set_subject, :on => :create
  after_create :send_response_email

  def recipient_email
    email
  end
  
  def send_response_email
    SiteMailer.course_email(course, name, email).deliver
  end

  def deliver_email
    SiteMailer.enquiry_details_requested_email(self, sales_contact.to_s).deliver
  end

  protected

    def set_subject
      self.subject = course.name
    end
end
