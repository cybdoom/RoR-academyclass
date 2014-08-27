require File.dirname(__FILE__) + '/../spec_helper'
 
describe SurveysController do
  fixtures :all
  render_views
  
  describe "not logged on" do
    describe "require login" do
      def hit_action(method, action)
        self.send(method, action)
        response.should redirect_to(login_path)
      end
      
      describe "index" do
        specify { hit_action(:get, :index) }
      end
      describe "new" do
        specify { hit_action(:get, :new) }
      end
      describe "create" do
        specify { hit_action(:post, :create) }
      end
      describe "edit" do
        specify { hit_action(:get, :edit) }
      end
      describe "update" do
        specify { hit_action(:put, :update) }
      end
    end
    describe "show" do
      before do
        Survey.should_receive(:find).with('1234').and_return @survey = Survey.new(:start_date => Date.new+3, :end_date => Date.new+5, :name => "Internets 101", :trainer => "Sarah Parky")
        get :show, { :id => 1234 }
      end
      specify { response.should render_template(:show) }
    end
  end
  
  describe "logged on" do
    before { @controller.should_receive(:check_admin).and_return true }
    describe "index" do
      before { get :index }
      specify { response.should render_template(:index) }
    end
    describe "new" do
      before { get :new }
      specify { response.should render_template(:new) }
    end
    describe "create" do
      pending
    end
    describe "edit" do
      pending
    end
    describe "update" do
      pending
    end
  end
end
