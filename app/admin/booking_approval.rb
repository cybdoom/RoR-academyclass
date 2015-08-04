ActiveAdmin.register BookingApproval do
  index do
    column :booking_form_id
    column :po_number
    column :name
    column :company_number
    column :job_title
    column :email
    column :phone
    column :email_to
    column :name_to
    default_actions
  end
end