ActiveAdmin.register BookingFormResponse do
  index do
    column :booking_form_id
    column :address
    column :delivery_address
    column :contact_name
    column :contact_phone
    column :proof_of_id
    column :projector
    column :software_installed
    column :latest_version
    column :software_details
    column :instructor_machine
    column :lunch_provided
    column :comments
    default_actions
  end
end