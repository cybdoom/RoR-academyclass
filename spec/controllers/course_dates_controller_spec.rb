require File.dirname(__FILE__) + '/../spec_helper'
 
describe CourseDatesController do

  describe "index" do
    before { Course.should_receive(:with_locations).and_return @courses = [Course.new] }
    describe 'all courses' do
      before { get :index, format: :xml }
      specify { response.should render_template("index") }
      specify { assigns[:courses].should == @courses }
      specify { assigns[:current].should be_false }
    end
    describe 'only current' do
      before { get :index, format: :xml, current: 1 }
      specify { response.should render_template("index") }
      specify { assigns[:courses].should == @courses }
      specify { assigns[:current].should be_true }
    end
  end

  describe 'not logged in' do
    describe "new" do
      before { get :new }
      specify { response.should redirect_to(login_path) }
    end
    describe "create" do
      before { post :create }
      specify { response.should redirect_to(login_path) }
    end
    describe "destroy" do
      before { delete :destroy }
      specify { response.should redirect_to(login_path) }
    end
  end

  describe "logged on" do
    describe 'destroy' do
      before do
        @controller.should_receive(:check_admin).and_return true
        CourseDate.should_receive(:find).with('1234').and_return @course_date = CourseDate.new({:course_id => 54321})
        @course_date.should_receive(:destroy)
        delete :destroy, {:id => "1234"}
      end
      specify { response.should redirect_to(edit_course_path(54321)) }
    end
  end
end