class AddFieldsForBookingApproval < ActiveRecord::Migration
  def change
    add_column :booking_approvals, :email_to, :string
    add_column :booking_approvals, :name_to, :string
  end
end
