class AddLsmToBookingForms < ActiveRecord::Migration
  def change
    add_column :booking_forms, :lsm, :boolean
  end
end
