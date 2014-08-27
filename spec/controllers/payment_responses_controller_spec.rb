require File.dirname(__FILE__) + '/../spec_helper'

describe PaymentResponsesController do

  describe 'create' do
    before do
      PaymentResponse.should_receive(:create_from_worldpay).with({'blah' => 'something'}).and_return @r = PaymentResponse.new
      post :create, {blah: 'something'}
    end
    specify { assigns[:response].should == @r }
    specify { assigns[:referrer].attributes.should == Referrer.new.attributes }
    specify { response.should render_template('referrers/new') }
  end

  describe 'not logged in' do
    describe 'index' do
      before { get :index }
      specify { response.should redirect_to(login_path) }
    end
    describe 'show' do
      before { get :show, id: 12 }
      specify { response.should redirect_to(login_path) }
    end
  end

  describe 'logged in' do
    before { @controller.stub(:check_backend_access).and_return true }
    describe 'index' do
      before do
        PaymentResponse.should_receive(:ordered).and_return @responses = [PaymentResponse.new]
        @responses.should_receive(:page).with('2').and_return @responses
        get :index, page: 2
      end
      specify { response.should render_template(:index) }
      specify { assigns[:responses].should == @responses }
    end
    describe 'show' do
      before do
        PaymentResponse.should_receive(:find).with('12').and_return @r = PaymentResponse.new
        get :show, id: 12
      end
      specify { response.should render_template(:show) }
      specify { assigns[:response].should == @r }
    end
  end
end