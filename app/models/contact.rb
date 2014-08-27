class Contact < EmailLog
  GOOGLE_TRACKING_CODE = <<-EOT
      <img height="1" width="1" style="border-style:none;" alt="" src="http://www.googleadservices.com/pagead/conversion/1065162354/?label=default&amp;guid=ON&amp;script=0"/>
  EOT

  def deliver_email
    SiteMailer.contact_email(self, sales_contact.to_s).deliver
  end
end