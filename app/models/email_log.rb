class EmailLog < ActiveRecord::Base
  validates_presence_of :name, :email, :type
  validates_format_of :email, :with => EMAIL_REGEX
  belongs_to :sales_contact
  before_update :set_dispatch_date
  after_update :deliver_email

  scope :of_type, lambda {|types| where('type IN (?)', types) }
  scope :after, lambda {|id| where("id > ?", id).order(:id) }
  scope :before, lambda {|id| where("id < ?", id).order('id DESC') }
  
  def type_name
    case self.class.to_s
      when "Contact" then return "Contact Us Form"
      when "NewsletterSubscription" then return "Newsletter Subscription"
      when "CourseDetailEnquiry" then return "Course Detail Email"
      when "CourseEnquiry" then return "Course Enquiry"
    end
  end
  
  # the email types which are assigned to AC sales people
  def self.assigned_types
    ["Contact", "CourseEnquiry"]
  end
  
  def assigned_type?
    course_enquiry? || contact?
  end
  
  def previous
    types = assigned_type? ? EmailLog.assigned_types : self.type.to_s
    EmailLog.of_type(types).before(id).first
  end
  
  def next
    types = assigned_type? ? EmailLog.assigned_types : self.type.to_s
    EmailLog.of_type(types).after(id).first
  end

  def dispatched?
    return !sales_contact.nil?
  end
  
  def recipient_name
    sales_contact_id ? sales_contact.name : nil
  end

  def recipient_email
    sales_contact_id ? sales_contact.email : nil
  end
  
  def default_recipient
    "training@academyclass.com"
  end
  
  def newsletter_subscription?
    self.class == NewsletterSubscription
  end
  
  def course_detail_enquiry?
    self.class == CourseDetailEnquiry
  end
  
  def course_enquiry?
    self.class == CourseEnquiry
  end
  
  def contact?
    self.class == Contact
  end
  
  def set_dispatch_date
    self.dispatched_at = Time.now unless sales_contact_id.nil?
  end

  #to be overriden in the child class
  def deliver_email
  end
end
