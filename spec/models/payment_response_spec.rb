require File.dirname(__FILE__) + '/../spec_helper'

describe PaymentResponse do

  describe 'create_from_worldpay' do
    before do
      @response = PaymentResponse.new
      PaymentResponse.should_receive(:new).and_return @response
      @response.should_receive(:process!).with('params')
    end
    specify { PaymentResponse.create_from_worldpay('params').should == @response }
  end

  describe 'successful_payment?' do
    specify { PaymentResponse.new(success: false, auth_amount: 655.90).successful_payment?.should be_false }
    specify { PaymentResponse.new(success: true, auth_amount: nil).successful_payment?.should be_false }
    specify { PaymentResponse.new(success: true, auth_amount: 655.90).successful_payment?.should be_true }
  end

  describe 'process!' do
    before do
      @form = PaymentResponse.new
      @form.should_receive(:update_payable).and_return true
      params = {cartId: 12, transId: 678, transStatus: 'good', authAmount: 677.40, rawAuthMessage: 'roar', :AVS => 'SVA', 
        wafMerchMessage: 'wtf?', authentication: 'alice/bob', ipAddress: '192.168.0.pwnd', callbackPW: 'abc', futurePayId: 999 }
      @form.process! params
      @fields = %w(payable_id payable_type transaction_id transaction_status auth_amount raw_auth_message avs waf_merch_message authentication ip_address)
    end
    specify { @form.should_not be_new_record }
    specify { @form.attributes.select {|k,v| @fields.include?(k) }.should ==  {'payable_id' => 12, 'payable_type' => 'BookingForm', 
      'transaction_id' => 678, 'transaction_status' => 'good', 'auth_amount' => 677.40, 'raw_auth_message' => 'roar', 'avs' => 'SVA', 
      'waf_merch_message' => 'wtf?', 'authentication' => 'alice/bob', 'ip_address' => '192.168.0.pwnd'} }
    specify { @form.instance_variable_get('@callback_password').should == 'abc' }
    specify { @form.instance_variable_get('@futurePayId').should == 999 }
  end

  describe 'update_payable' do
    before do
      @response = PaymentResponse.new(payable_type: 'BookingForm', transaction_status: 'Y', auth_currency: 'GBP')
      @response.instance_variable_set('@callback_password', WORLDPAY_CALLBACK_PASSWORD)
    end      
    describe 'password mismatch' do
      before do
        @response.instance_variable_set('@callback_password', 'notgood')
        @response.should_not_receive(:update_booking)
        @result = @response.update_payable
      end
      specify { @result.should be_true }
      specify { @response.success.should be_false }
      specify { @response.processed_message.should == 'Invalid callback password (notgood) Ignoring this response' }
    end
    describe 'bad transaction status' do
      before do
        @response.transaction_status = 'C'
        @response.should_not_receive(:update_booking)
        @result = @response.update_payable
      end
      specify { @result.should be_true }
      specify { @response.success.should be_false }
      specify { @response.processed_message.should == 'Transaction cancelled (response status should be \'Y\')' }
    end
    describe 'invalid currency' do
      before do
        @response.auth_currency = 'NZD'
        @response.should_not_receive(:update_booking)
        @result = @response.update_payable
      end
      specify { @result.should be_true }
      specify { @response.success.should be_false }
      specify { @response.processed_message.should == 'Invalid currency (should be GBP)' }
    end
    describe 'all good' do
      before do
        @response.should_receive(:update_booking)
        @result = @response.update_payable
      end
      specify { @result.should be_true }
      specify { @response.success.should be_false }
      specify { @response.processed_message.should be_nil }
    end
  end

  describe 'update_booking' do
    describe 'where booking form doesn\'t exist' do
      before do
        @response = PaymentResponse.new(payable_id: 74)
        @response.update_booking
      end
      specify { @response.processed_message.should == 'Booking not found with ID 74' }
      specify { @response.success.should be_false }
    end
    describe 'where booking form cant\'t be paid' do
      before do
        @response = PaymentResponse.new(payable_id: FactoryGirl.create(:booking_form, status: BookingForm::CANCELLED).id)
        BookingForm.any_instance.should_not_receive(:payment_received!)
        @response.update_booking
      end
      specify { @response.processed_message.should == 'Booking does not have pending status (status currently Cancelled)' }
      specify { @response.success.should be_false }
    end
    describe 'split payment authorisation' do
      before do
        BookingForm.should_receive(:find).with(12).and_return @form = BookingForm.new(first_payment_date: Date.today)
        @form.should_receive(:can_be_paid?).and_return true
        @form.should_receive(:payment_received!)
        @response = PaymentResponse.new(payable_id: 12)
        @response.instance_variable_set('@futurePayId', 999)
        @response.update_booking
      end
      specify { @response.processed_message.should == 'Split payments approved successfully' }
      specify { @response.success.should be_true }
    end
    describe 'invalid payment amount' do
      before do
        BookingForm.should_receive(:find).with(12).and_return @form = BookingForm.new
        @form.should_receive(:can_be_paid?).and_return true
        @form.should_not_receive(:payment_received!)
        @form.should_receive(:valid_payment_amount?).with(566.74).and_return false
        @form.stub(:payment_amount).and_return 566.73
        @response = PaymentResponse.new(payable_id: 12, auth_amount: 566.74)
        @response.update_booking
      end
      specify { @response.processed_message.should == 'Booking amount mismatch (should be 566.73)' }
      specify { @response.success.should be_false }
    end
    describe 'split payment authorisation' do
      before do
        BookingForm.should_receive(:find).with(12).and_return @form = BookingForm.new
        @form.should_receive(:can_be_paid?).and_return true
        @form.should_receive(:payment_received!)
        @form.should_receive(:valid_payment_amount?).with(566.74).and_return true
        @response = PaymentResponse.new(payable_id: 12, auth_amount: 566.74)
        @response.update_booking
      end
      specify { @response.processed_message.should == 'Payment completed successfully' }
      specify { @response.success.should be_true }
    end
  end
end