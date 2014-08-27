require File.dirname(__FILE__) + '/../spec_helper'
 
describe ProductParentsController do

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
end
