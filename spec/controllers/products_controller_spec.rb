require File.dirname(__FILE__) + '/../spec_helper'
 
describe ProductsController do
  
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

  describe 'show' do
    describe 'not found' do
      before do
        Product.should_receive(:find_by_name).with('PHP').and_return nil
        get :show, product: 'PHP', product_parent: 'ignored'
      end
      specify { response.should render_template('not_found') }
    end
    describe 'valid product' do
      before do
        Product.should_receive(:find_by_name).with('PHP/MySQL').and_return @product = Product.new
        get :show, product: 'PHP', product2: 'MySQL', product_parent: 'ignored'
      end
      specify { response.should render_template('show') }
      specify { assigns[:product].should == @product }
      specify { assigns[:name].should == 'PHP/MySQL' }
      specify { assigns[:parent].should == 'ignored' }
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
