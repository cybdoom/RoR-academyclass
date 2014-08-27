require File.dirname(__FILE__) + '/../spec_helper'
 
describe CoursesController do
  describe "not logged in" do
    describe 'index' do
      before { get :index }
      specify { response.should redirect_to(login_path) }
    end
    describe 'new' do
      before { get :new }
      specify { response.should redirect_to(login_path) }
    end
    describe 'create' do
      before { post :create }
      specify { response.should redirect_to(login_path) }
    end
    describe 'edit' do
      before { get :edit, id: 12 }
      specify { response.should redirect_to(login_path) }
    end
    describe 'update' do
      before { post :update, id: 12 }
      specify { response.should redirect_to(login_path) }
    end
    describe 'destroy' do
      before { post :destroy, id: 12 }
      specify { response.should redirect_to(login_path) }
    end
  end
  
  describe "logged in" do
    before { @controller.should_receive(:check_admin).and_return true }
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
    
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe 'courses' do
    before do
      ProductParent.should_receive(:with_courses).and_return @parents = [ProductParent.new]
      get :courses, format: :xml
    end
    specify { response.should render_template(:courses) }
    specify { assigns[:manufacturers].should == @parents }
  end

  describe 'course_dates' do
    before do
      ProductParent.should_receive(:with_dates_and_locations).and_return @parents = [ProductParent.new]
      @parents.should_receive(:after_today).and_return @parents
      get :course_dates, format: :xml
    end
    specify { response.should render_template(:course_dates) }
    specify { assigns[:manufacturers].should == @parents }
  end

  describe 'course_dates' do
    before do
      ProductParent.should_receive(:with_dates_and_locations).and_return @parents = [ProductParent.new]
      get :courses_with_dates, format: :xml
    end
    specify { response.should render_template(:courses_with_dates) }
    specify { assigns[:manufacturers].should == @parents }
  end
end