class BookingAmendmentsController < ApplicationController
  def create
    @amendment = BookingAmendment.new(params[:booking_amendment])
    form = BookingForm.where(:password => params[:password]).find(@amendment.booking_form_id)
    if form.password == params[:password] && @amendment.save
      flash[:error] = "Your booking amendment has been submitted sucessfully"
    end
    redirect_to booking_form_path(@amendment.booking_form_id, :p => form.password)
  end
end