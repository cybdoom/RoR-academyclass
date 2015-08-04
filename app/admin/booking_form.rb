ActiveAdmin.register BookingForm do
  index do
    column :contact_name
    column :email
    column :telephone
    column :company
    column :address
    column :postcode
    column :salesperson
    column :allow_invoice
    column :vat_rate
    column :status
    column :created_at
    column :valid_to
    column :password
    column :filemaker_code
    column :booking_type
    column :updated_at
    column :first_payment_date
    column :lsm
    column :payment_count
    default_actions
  end
end