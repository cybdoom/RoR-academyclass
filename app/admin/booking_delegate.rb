ActiveAdmin.register BookingDelegate do
  index do
    column :booking_form_id
    column :name
    column :course_name
    column :course_location
    column :start_date
    column :end_date
    column :platform_pc
    column :price
    column :booking_type
    column :email
    column :platform
    default_actions
  end
end