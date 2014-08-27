module BookingFormHelper

  def display_platform(del)
    return "Not specified" if del.platform_pc.nil?
    del.platform_pc ? "PC" : "Mac"
  end

  def show_delegate_email
    params[:action] == "edit"
  end

  def booking_form_statuses
    [["Outstanding",1], ["Cancelled",2], ["Part Paid", 4], ["Completed",3]]
  end

  def booking_payment_schedule
    @booking.payment_schedule.map {|date| date.strftime('%d %B %Y') }.join(', ')
  end
end