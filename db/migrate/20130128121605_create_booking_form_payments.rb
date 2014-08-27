class CreateBookingFormPayments < ActiveRecord::Migration
  def change
    add_column :booking_forms, :first_payment_date, :date
  end
end
