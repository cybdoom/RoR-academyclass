require File.dirname(__FILE__) + '/../spec_helper'

describe 'BookingForm' do

  describe 'create_or_update' do
    before do
      @attributes = %w(contact_name email telephone company address postcode salesperson allow_invoice vat_rate filemaker_code booking_type first_payment_date lsm payment_count)
      @del_attributes = %w(name course_name course_location start_date end_date platform_pc price booking_type email)
    end
    describe 'with new form' do
      before do
        @form = BookingForm.create_or_update({'contact_name' => 'Josh Howie', 'email' => 'josh@howie.com', 'telephone' => '123', 'company' => 'ABC Worx', 'address' => '123 X St', 'postcode' => 'EC1', 'salesperson' => 'Sarah Patton', 'allow_invoice' => '1', 'vat_rate' => '0.175', 'filemaker_code' => 'FMR', 'booking_type' => 'Scheduled', 'first_payment_date' => '2013-01-01', 'lsm' => '0', 'payment_count' => '3', 'delegates_attributes' => [{'name' => 'Joe Delegate', 'course_name' => 'Photoshop 101', 'course_location' => 'Glasgow', 'start_date' => '2016-04-01', 'end_date' => '2016-04-04', 'platform_pc' => '1', 'price' => '566.00', 'booking_type' => 'mclass', 'email' => 'joe@person.co'}, {'name' => 'Sam Smith', 'course_name' => 'PHP 101', 'course_location' => 'London', 'start_date' => '2017-04-01', 'end_date' => '2017-04-04', 'platform_pc' => '0', 'price' => '1012.55', 'booking_type' => 'mclass', 'email' => 'sam@person.co'}]})
      end
      specify { @form.should be_new_record }
      specify { @form.reset.should be_true }
      specify { @form.attributes.select {|k,v| @attributes.include?(k) }.should == {'contact_name' => 'Josh Howie', 'email' => 'josh@howie.com', 'telephone' => '123', 'company' => 'ABC Worx', 'address' => '123 X St', 'postcode' => 'EC1', 'salesperson' => 'Sarah Patton', 'allow_invoice' => true, 'vat_rate' => 0.175, 'filemaker_code' => 'FMR', 'booking_type' => 'Scheduled', 'first_payment_date' => Date.new(2013, 1, 1), 'lsm' => false, 'payment_count' => 3} }
      specify { @form.delegates.length.should == 2 }
      specify { @form.delegates.first.attributes.select {|k,v| @del_attributes.include?(k) }.should == {'name' => 'Joe Delegate', 'course_name' => 'Photoshop 101', 'course_location' => 'Glasgow', 'start_date' => Date.new(2016,4,1), 'end_date' => Date.new(2016, 4, 4), 'platform_pc' => true, 'price' => 566.00, 'booking_type' => 'mclass', 'email' => 'joe@person.co'} }
      specify { @form.delegates.last.attributes.select {|k,v| @del_attributes.include?(k) }.should == {'name' => 'Sam Smith', 'course_name' => 'PHP 101', 'course_location' => 'London', 'start_date' => Date.new(2017,4,1), 'end_date' => Date.new(2017,4,4), 'platform_pc' => false, 'price' => 1012.55, 'booking_type' => 'mclass', 'email' => 'sam@person.co'} }
    end
    describe 'with existing form' do
      describe 'with matching delegates' do
        before(:all) do
          FactoryGirl.create(:booking_form, filemaker_code: 'FMR', delegates: [FactoryGirl.create(:booking_delegate, name: 'Joe Delegate', course_name: 'Photoshop 101', course_location: 'Glasgow', start_date: '2016-04-01', end_date: '2016-04-04', platform_pc: true, price: 566.0, booking_type: 'mclass', email: 'joe@person.co'), FactoryGirl.create(:booking_delegate, name: 'Sam Smith', course_name: 'PHP 101', course_location: 'London', start_date: '2017-04-01', end_date: '2017-04-04', platform_pc: false, price: 1012.55, booking_type: 'mclass', email: 'sam@person.co')])
          @form = BookingForm.create_or_update({'contact_name' => 'Josh Howie', 'email' => 'josh@howie.com', 'telephone' => '123', 'company' => 'ABC Worx', 'address' => '123 X St', 'postcode' => 'EC1', 'salesperson' => 'Sarah Patton', 'allow_invoice' => '1', 'vat_rate' => '0.175', 'filemaker_code' => 'FMR', 'booking_type' => 'Scheduled', 'first_payment_date' => '2013-01-01', 'lsm' => '0', 'payment_count' => '3', 'delegates_attributes' => [{'name' => 'Joe Delegate', 'course_name' => 'Photoshop 101', 'course_location' => 'Glasgow', 'start_date' => '2016-04-01', 'end_date' => '2016-04-04', 'platform_pc' => '1', 'price' => '566.00', 'booking_type' => 'mclass', 'email' => 'joe@person.co'}, {'name' => 'Sam Smith', 'course_name' => 'PHP 101', 'course_location' => 'London', 'start_date' => '2017-04-01', 'end_date' => '2017-04-04', 'platform_pc' => '0', 'price' => '1012.55', 'booking_type' => 'mclass', 'email' => 'sam@person.co'}]})
        end
        after(:all) { delete_all %w(booking_forms booking_delegates) }
        specify { @form.should_not be_new_record }
        specify { @form.reset.should be_true }
        specify { @form.attributes.select {|k,v| @attributes.include?(k) }.should == {'contact_name' => 'Josh Howie', 'email' => 'josh@howie.com', 'telephone' => '123', 'company' => 'ABC Worx', 'address' => '123 X St', 'postcode' => 'EC1', 'salesperson' => 'Sarah Patton', 'allow_invoice' => true, 'vat_rate' => 0.175, 'filemaker_code' => 'FMR', 'booking_type' => 'Scheduled', 'first_payment_date' => Date.new(2013, 1, 1), 'lsm' => false, 'payment_count' => 3} }
        specify { @form.delegates.length.should == 2 }
        specify { @form.delegates.first.should_not be_new_record }
        specify { @form.delegates.last.should_not be_new_record }
        specify { @form.delegates.first.attributes.select {|k,v| @del_attributes.include?(k) }.should == {'name' => 'Joe Delegate', 'course_name' => 'Photoshop 101', 'course_location' => 'Glasgow', 'start_date' => Date.new(2016,4,1), 'end_date' => Date.new(2016, 4, 4), 'platform_pc' => true, 'price' => 566.00, 'booking_type' => 'mclass', 'email' => 'joe@person.co'} }
        specify { @form.delegates.last.attributes.select {|k,v| @del_attributes.include?(k) }.should == {'name' => 'Sam Smith', 'course_name' => 'PHP 101', 'course_location' => 'London', 'start_date' => Date.new(2017,4,1), 'end_date' => Date.new(2017,4,4), 'platform_pc' => false, 'price' => 1012.55, 'booking_type' => 'mclass', 'email' => 'sam@person.co'} }
      end
      describe 'with mismatched delegates' do
        before(:all) do
          FactoryGirl.create(:booking_form, filemaker_code: 'FMR', delegates: [FactoryGirl.create(:booking_delegate)])
          @form = BookingForm.create_or_update({'contact_name' => 'Josh Howie', 'email' => 'josh@howie.com', 'telephone' => '123', 'company' => 'ABC Worx', 'address' => '123 X St', 'postcode' => 'EC1', 'salesperson' => 'Sarah Patton', 'allow_invoice' => '1', 'vat_rate' => '0.175', 'filemaker_code' => 'FMR', 'booking_type' => 'Scheduled', 'first_payment_date' => '2013-01-01', 'lsm' => '0', 'payment_count' => '3', 'delegates_attributes' => [{'name' => 'Joe Delegate', 'course_name' => 'Photoshop 101', 'course_location' => 'Glasgow', 'start_date' => '2016-04-01', 'end_date' => '2016-04-04', 'platform_pc' => '1', 'price' => '566.00', 'booking_type' => 'mclass', 'email' => 'joe@person.co'}, {'name' => 'Sam Smith', 'course_name' => 'PHP 101', 'course_location' => 'London', 'start_date' => '2017-04-01', 'end_date' => '2017-04-04', 'platform_pc' => '0', 'price' => '1012.55', 'booking_type' => 'mclass', 'email' => 'sam@person.co'}]})
        end
        after(:all) { delete_all %w(booking_forms booking_delegates) }
        specify { @form.should_not be_new_record }
        specify { @form.reset.should be_true }
        specify { @form.attributes.select {|k,v| @attributes.include?(k) }.should == {'contact_name' => 'Josh Howie', 'email' => 'josh@howie.com', 'telephone' => '123', 'company' => 'ABC Worx', 'address' => '123 X St', 'postcode' => 'EC1', 'salesperson' => 'Sarah Patton', 'allow_invoice' => true, 'vat_rate' => 0.175, 'filemaker_code' => 'FMR', 'booking_type' => 'Scheduled', 'first_payment_date' => Date.new(2013, 1, 1), 'lsm' => false, 'payment_count' => 3} }
        specify { @form.delegates.length.should == 2 }
        specify { @form.delegates.first.should be_new_record }
        specify { @form.delegates.last.should be_new_record }
        specify { @form.delegates.first.attributes.select {|k,v| @del_attributes.include?(k) }.should == {'name' => 'Joe Delegate', 'course_name' => 'Photoshop 101', 'course_location' => 'Glasgow', 'start_date' => Date.new(2016,4,1), 'end_date' => Date.new(2016, 4, 4), 'platform_pc' => true, 'price' => 566.00, 'booking_type' => 'mclass', 'email' => 'joe@person.co'} }
        specify { @form.delegates.last.attributes.select {|k,v| @del_attributes.include?(k) }.should == {'name' => 'Sam Smith', 'course_name' => 'PHP 101', 'course_location' => 'London', 'start_date' => Date.new(2017,4,1), 'end_date' => Date.new(2017,4,4), 'platform_pc' => false, 'price' => 1012.55, 'booking_type' => 'mclass', 'email' => 'sam@person.co'} }
      end
    end
  end

  describe 'delete_delegates_if_mismatched' do
    before(:all) { @form = FactoryGirl.create(:booking_form, delegates: [FactoryGirl.create(:booking_delegate)]) }
    after(:all) { delete_all %w(booking_forms booking_delegates) }
    before { @hash = {'delegates_attributes' => 'abc', 'xyz' => '123'} }
    describe 'all delegates match' do
      before do
        @form.should_receive(:all_delegates_match?).with('abc').and_return true
        @form.delete_delegates_if_mismatched @hash
      end
      specify { @hash.should == {'xyz' => '123'} }
      specify { @form.delegates.length.should == 1 }
      specify { @form.reset.should be_false }
    end
    describe 'all delegates don\'t match' do
      before do
        @form.should_receive(:all_delegates_match?).with('abc').and_return false
        @form.delete_delegates_if_mismatched @hash
      end
      specify { @hash.should == {'delegates_attributes' => 'abc', 'xyz' => '123'} }
      specify { @form.delegates.length.should == 0 }
      specify { @form.reset.should be_true }
    end
  end

  describe 'all_delegates_match?' do
    before { @form = BookingForm.new }
    describe 'true' do
      before do
        @form.should_receive(:a_delegate_matches?).with('a').and_return true
        @form.should_receive(:a_delegate_matches?).with('b').and_return true
        @form.should_receive(:a_delegate_matches?).with('c').and_return true
      end
      specify { @form.all_delegates_match?(%w(a b c)).should be_true }
    end
    describe 'false' do
      before do
        @form.should_receive(:a_delegate_matches?).with('a').and_return true
        @form.should_receive(:a_delegate_matches?).with('b').and_return true
        @form.should_receive(:a_delegate_matches?).with('c').and_return false
      end
      specify { @form.all_delegates_match?(%w(a b c)).should be_false }
    end
  end

  describe 'a_delegate_matches?' do
    before { @form = BookingForm.new }
    describe 'true' do
      before do
        delegate1 = BookingDelegate.new
        delegate1.should_receive(:matches?).with('a').and_return false
        delegate2 = BookingDelegate.new
        delegate2.should_receive(:matches?).with('a').and_return true
        @form.delegates = [delegate1, delegate2]
      end
      specify { @form.a_delegate_matches?('a').should be_true }
    end
    describe 'false' do
      before do
        delegate1 = BookingDelegate.new
        delegate1.should_receive(:matches?).with('a').and_return false
        delegate2 = BookingDelegate.new
        delegate2.should_receive(:matches?).with('a').and_return false
        @form.delegates = [delegate1, delegate2]
      end
      specify { @form.a_delegate_matches?('a').should be_false }
    end
  end

  describe 'split payment' do
    specify { BookingForm.new(first_payment_date: Date.today).split_payment?.should be_true }
    specify { BookingForm.new(first_payment_date: nil).split_payment?.should be_false }
  end

  describe 'payment_schedule' do
    describe 'not split payment' do
      specify { BookingForm.new.payment_schedule.should be_nil }
    end
    describe 'split payment' do
      specify { BookingForm.new(first_payment_date: Date.new(2013, 10, 16), payment_count: 1).payment_schedule.should == [Date.new(2013,10,16)] }
      specify { BookingForm.new(first_payment_date: Date.new(2013, 10, 16), payment_count: 2).payment_schedule.should == [Date.new(2013,10,16), Date.new(2013,11,16)] }
      specify { BookingForm.new(first_payment_date: Date.new(2013, 10, 16), payment_count: 4).payment_schedule.should == [Date.new(2013,10,16), Date.new(2013,11,16), Date.new(2013,12,16), Date.new(2014,1,16)] }
    end
  end

  describe 'valid_payment_amount' do
    before do
      @form = BookingForm.new
      @form.stub(:payment_amount).and_return(73.45)
    end
    specify { @form.valid_payment_amount?(73.45).should be_true }
    specify { @form.valid_payment_amount?(73.46).should be_false }
  end

  describe 'payment_amount' do
    describe 'single payment' do
      before do
        @form = BookingForm.new(first_payment_date: nil, payment_count: 2)
        @form.stub(:total).and_return 1340.20
      end
      specify { @form.payment_amount.should == 1340.20 }
    end
    describe 'split' do
      describe '2 payments' do
        before do
          @form = BookingForm.new(first_payment_date: Date.today, payment_count: 2)
          @form.stub(:total).and_return 1340.20
        end
        specify { @form.payment_amount.should == 670.10 }
      end
      describe '3 payments' do
        before do
          @form = BookingForm.new(first_payment_date: Date.today, payment_count: 3)
          @form.stub(:total).and_return 1340.20
        end
        specify { @form.payment_amount.should == 446.73 }
      end
    end
  end

  describe 'payment_received' do
    before { @form = BookingForm.new }
    describe 'split payment' do
      before { @form.stub(:split_payment?).and_return true }
      describe '2 payments with' do
        before { @form.payment_count = 2 }
        describe 'some payments received' do
          before do
            @form.stub(:successful_payments_received).and_return 0
            @form.should_receive(:mark_part_paid!)
          end
          specify { @form.payment_received!.should be_nil }
        end
        describe 'all payments received' do
          before do
            @form.stub(:successful_payments_received).and_return 1
            @form.should_receive(:set_status).with(BookingForm::PAID)
          end
          specify { @form.payment_received!.should be_nil }
        end
      end
      describe '3 payments with' do
        before { @form.payment_count = 3 }
        describe 'some payments received' do
          before do
            @form.stub(:successful_payments_received).and_return 1
            @form.should_receive(:mark_part_paid!)
          end
          specify { @form.payment_received!.should be_nil }
        end
        describe 'all payments received' do
          before do
            @form.stub(:successful_payments_received).and_return 2
            @form.should_receive(:set_status).with(BookingForm::PAID)
          end
          specify { @form.payment_received!.should be_nil }
        end
      end
    end
    describe 'single payment' do
      before { @form.should_receive(:set_status).with(BookingForm::PAID) }
      specify { @form.payment_received!.should be_nil }
    end
  end

  describe 'successful_payments_received' do
    before do
      response1 = PaymentResponse.new
      response1.should_receive(:successful_payment?).and_return true
      response2 = PaymentResponse.new
      response2.should_receive(:successful_payment?).and_return true
      response3 = PaymentResponse.new
      response3.should_receive(:successful_payment?).and_return false
      @form = BookingForm.new(payment_responses: [response1, response2, response3])
    end
    specify { @form.successful_payments_received.should == 2 }
  end

  describe 'vat' do
    before { @form = BookingForm.new }
    describe 'zero' do
      before { @form.vat_rate = 0 }
      specify { @form.vat.should == 0 }
    end
    describe '17.5%' do
      before { @form.vat_rate = 0.175 }
      specify { @form.vat.should == 17.5 }
    end
  end

  describe 'total_ex_vat' do
    before { @form = BookingForm.new(delegates: [BookingDelegate.new(price: 175.90), BookingDelegate.new(price: 990.50), BookingDelegate.new(price: 2150)]) }
    specify { @form.total_ex_vat.should == 3316.40 }
  end

  describe 'total' do
    before do
      @form = BookingForm.new(vat_rate: 0.175)
      @form.should_receive(:total_ex_vat).and_return 558.20
    end
    specify { @form.total.should == 655.89 }
  end

  describe 'worldpay_form_options' do
    before do
      @form = BookingForm.new(contact_name: 'Joe Wilkinson', address: '23 Someplace Street', postcode: 'EC1A 2VV', telephone: '07234234523', email: 'joe@comedy.com')
      @form.stub(:id).and_return 12
      @form.stub(:total).and_return 753.45
    end
    describe 'single payment' do
      specify { @form.worldpay_form_options.should == { desc: "Academy Class Booking", currency: "GBP", name: 'Joe Wilkinson',address: '23 Someplace Street', postcode: 'EC1A 2VV', country: "GB", tel: '07234234523', email: 'joe@comedy.com', instId: WORLDPAY_INSTALLATION_ID, cartId: 12, testMode: 100, amount: 753.45 } }
    end
    describe 'split payment' do
      before { Date.stub(:today).and_return Date.new(2013, 10, 15) }
      describe 'first date is today' do
        before do
          @form.first_payment_date = Date.new(2013, 10, 15)
          @form.payment_count = 3
        end
        specify { @form.worldpay_form_options.should == { futurePayType: 'regular', option: 0, normalAmount: 251.15, intervalUnit: 3, intervalMult: 1, amount: 251.15, startDate: '2013-11-15', noOfPayments: 2, desc: "Academy Class Booking", currency: "GBP", name: 'Joe Wilkinson',address: '23 Someplace Street', postcode: 'EC1A 2VV', country: "GB", tel: '07234234523', email: 'joe@comedy.com', instId: WORLDPAY_INSTALLATION_ID, cartId: 12, testMode: 100 } }
      end
      describe 'first date is tomorrow' do
        before do
          @form.first_payment_date = Date.new(2013, 10, 16)
          @form.payment_count = 3
        end
        specify { @form.worldpay_form_options.should == { futurePayType: 'regular', option: 0, normalAmount: 251.15, intervalUnit: 3, intervalMult: 1, startDate: '2013-10-16', noOfPayments: 3, desc: "Academy Class Booking", currency: "GBP", name: 'Joe Wilkinson',address: '23 Someplace Street', postcode: 'EC1A 2VV', country: "GB", tel: '07234234523', email: 'joe@comedy.com', instId: WORLDPAY_INSTALLATION_ID, cartId: 12, testMode: 100 } }
      end
    end
  end
end