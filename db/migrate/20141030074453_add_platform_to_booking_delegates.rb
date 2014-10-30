class AddPlatformToBookingDelegates < ActiveRecord::Migration
  def change
    add_column :booking_delegates, :platform, :integer
  end
end
