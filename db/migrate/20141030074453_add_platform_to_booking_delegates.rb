class AddPlatformToBookingDelegates < ActiveRecord::Migration
  def change
    add_column :booking_delegates, :platform, :integer, default: 0, null: false
  end
end
