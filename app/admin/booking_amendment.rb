ActiveAdmin.register BookingAmendment do
  index do
    column :booking_form_id
    column :description
    default_actions
  end
end