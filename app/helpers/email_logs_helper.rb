module EmailLogsHelper

  def email_type_description
    case(@type)
      when "Enquiry" then return "An contact us, creative licence or course enquiry to be followed up by a salesperson"
      when "Contact" then return "A Contact Us form submission"
      when "NewsletterSubscription" then return "Requests to be signed up for the Academy Class newsletter"
      when "CourseDetailEnquiry" then return "Requests to have course details emailed (by clicking Email Me the Details on a course)"
      when "CourseEnquiry" then return "Enquiry box completion on a course, with selected course location and date"
      when "CreativeLicenceEnquiry" then return "Registrations on the Creative Licence page"
    end
  end
  

  def email_enquiry_options
    options_for_select [["Enquires Requiring Follow up", "Enquiry"], ["Newsletter Subscriptions", "NewsletterSubscription"], ["Course Detail Emails", "CourseDetailEnquiry"]], @type
  end

  def salesperson_options
    [[" - select salesperson - ", nil]] + SalesContact.all.map{|s|[s.to_s, s.id]}
  end
end