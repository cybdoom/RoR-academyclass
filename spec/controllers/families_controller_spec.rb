require File.dirname(__FILE__) + '/../spec_helper'
 
describe FamiliesController do
  describe 'not logged in' do
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

  describe 'show' do
    before do
      Family.should_receive(:with_products).and_return @family = Family.new
      @family.should_receive(:find_by_slug).with('abc').and_return @family
      Family.should_receive(:all).and_return @families = [Family.new, @family]
      get :show, id: 'abc'
    end
    specify { response.should render_template(:show) }
    specify { assigns[:family].should == @family }
    specify { assigns[:families].should == @families }
  end
end