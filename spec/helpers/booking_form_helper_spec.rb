require File.dirname(__FILE__) + '/../spec_helper'
 
describe BookingFormHelper do

  describe 'booking_payment_schedule' do
    before { @booking = double('BookingForm', payment_schedule: [Date.new(2013, 10, 16), Date.new(2013, 11, 16)]) }
    specify { booking_payment_schedule.should == '16 October 2013, 16 November 2013' }
  end
end