class AddPaymentCountToBookingForm < ActiveRecord::Migration
  def change
    add_column :booking_forms, :payment_count, :integer

    execute 'UPDATE booking_forms SET payment_count=2 WHERE first_payment_date IS NOT NULL'
    BookingForm.where('first_payment_date IS NOT NULL').includes(:payment_responses).each do |f|
      if f.successful_payments_received == 2
        f.status = BookingForm::PAID
        f.save
      end
    end
  end
end
