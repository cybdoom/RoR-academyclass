class CourseDetailEnquiry < EmailLog
  # Created when someone clicks the "email me the details" link
  attr_accessible :name, :email, :course_id
  belongs_to :course
  validates_presence_of :course_id
  before_validation :set_subject, :on => :create
  after_create :deliver_email

  def recipient_email
    email
  end
  
  def deliver_email
    SiteMailer.course_email(course, name, email).deliver
  end

  protected

    def set_subject
      self.subject = course.name
    end
end
