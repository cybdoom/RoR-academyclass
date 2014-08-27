require File.dirname(__FILE__) + '/../spec_helper'
 
describe EmailLogsController do
  it "should render the contact page" do
    get :new
    response.should render_template(:new)
  end

  describe 'create' do
    before do
      @contact = Contact.new
      Contact.should_receive(:new).with('oaras').and_return @contact
    end
    describe 'successfully' do
      before do
        @contact.should_receive(:save).and_return true
        post :create, {contact: 'oaras'}
      end
      specify { response.body.should == "Your message has been sent successfully\n#{Contact::GOOGLE_TRACKING_CODE}" }
      specify { response.status.should == 200 }
    end
    describe 'unsuccessfully' do
      before do
        @contact.should_receive(:save).and_return false
        post :create, {contact: 'oaras'}
      end
      specify { response.body.should be_blank }
      specify { response.status.should == 500 }
    end
  end
  
  describe "newsletter subscription action" do
    before do
      @newsletter = NewsletterSubscription.new
      NewsletterSubscription.should_receive(:new).with('params').and_return @newsletter
    end
    describe "success" do
      before do
        @newsletter.should_receive(:save).and_return true
        post :newsletter_subscription, newsletter_subscription: 'params', format: :js 
      end
      specify { flash[:message].should == "You have been added to the subscriber list" }
      specify { response.should render_template("newsletter_subscription") }
    end
    describe "failure" do
      before do
        @newsletter.should_receive(:save).and_return false
        post :newsletter_subscription, newsletter_subscription: 'params', format: :js
      end
      specify { response.should render_template("_newsletter_subscription") }
      specify { flash[:error].should == "Your email address is invalid. Please check it." }
    end
  end
  
  describe "course enquiry action" do
    before do
      @enquiry = CourseEnquiry.new
      CourseEnquiry.should_receive(:new).with('params').and_return @enquiry
    end
    describe "success" do
      before do
        @enquiry.should_receive(:save).and_return true
        post :course_enquiry, {course_enquiry: 'params'}
      end
      specify { response.should include_text("adwordstracking.htm") }
      specify { response.should include_text("Your enquiry has been made successfully") }
    end
    describe "failure" do
      before do
        @enquiry.should_receive(:save).and_return false
        post :course_enquiry, {course_enquiry: 'params'}
      end
      specify { response.should include_text("Please enter your name, a valid email address and an enquiry.") }
    end
  end
end
