class SiteMailer < ActionMailer::Base
  helper CoursesHelper, BookingFormHelper
  
  default :from => "Academy Class Website <training@academyclass.com>"
  default_url_options[:host] = Rails.env.production? ? "www.academyclass.com" : "staging.academyclass.com"
  
  def contact_email(contact, recipient)
    @contact = contact
    mail(:subject => "Academy Class Contact", :to => recipient_address(recipient))
  end
  
  def enquiry_email(enquiry, recipient)
    @enquiry = enquiry
    mail(:subject => "Academy Class Enquiry: #{enquiry.subject}", :to => recipient_address(recipient))
  end

  def enquiry_details_requested_email(enquiry, recipient)
    @enquiry = enquiry
    mail(:subject => "Academy Class Enquiry Detalis Requested: #{enquiry.subject}", :to => recipient_address(recipient))
  end
  
  def course_email(course, name, email)
    @course = course
    @name = name
    mail(:subject => "Academy Class Course Details: #{course.name}", :to => recipient_address("#{name} <#{email}>"))
  end
  
  def course_enquiry_response_email(course_enquiry)
    mail(:subject => "Thank you for your Academy Class enquiry", :to => recipient_address("#{course_enquiry.name} <#{course_enquiry.email}>"))
  end
  
  def creative_licence_email(creative_licence_enquiry, recipient)
    @creative_licence_enquiry = creative_licence_enquiry
    mail(:subject => "Academy Class Creative Licence Enquiry: #{creative_licence_enquiry.subject}", :to => recipient_address(recipient))
  end
  
  def booking_form_email(booking_form)
    @booking_form = booking_form
    mail(:subject => "Academy Class Booking Form", :to => recipient_address(booking_form.email), :from => "Academy Class <training@academyclass.com>")
  end
  
  def booking_amendment_email(amendment)
    @amendment = amendment
    @booking = amendment.booking_form
    mail(:subject => "Amendment requested for online booking form", :to => recipient_address("Academy Class <training@academyclass.com>"))
  end
  
  def upload_completion_email(upload_count, errors, user)
    @upload_count = upload_count
    @errors = errors
    mail(:subject => "Your Academy Class user upload has completed", :to => recipient_address("#{user.name} <#{user.email}>"))
  end
  
  def new_user_email(user)
    @user = user
    mail(:subject => "Access to the Academy Class Training Videos setup", :to => recipient_address("#{user.name} <#{user.email}>"))
  end
  
  def video_access_email(user)
    @user = user
    mail(:subject => "Access to the Academy Class Training Videos setup", :to => recipient_address("#{user.name} <#{user.email}>"))
  end

  def date_csv_email(filename)
    attachments['dates.csv'] = File.read Rails.root.join(filename)
    mail(subject: "Academy Class course dates and seats sold", to: recipient_address("Stuart Low <stuart@breezemedia.co.uk>"))
  end
  
  private
  def recipient_address(to)
    Rails.env.development? ? "Jonathon Horsman (TEST) <jonathon@arctickiwi.com>" : to
  end
end
