class BookingAmendment < ActiveRecord::Base
  belongs_to :booking_form
  after_create :update_booking, :send_email
  
  def send_email
    SiteMailer.booking_amendment_email(self).deliver
  end
  
  def update_booking
    self.booking_form.status = BookingForm::AMENDED
    self.booking_form.save
  end
end