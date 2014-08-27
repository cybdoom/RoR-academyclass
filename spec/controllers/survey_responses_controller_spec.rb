require File.dirname(__FILE__) + '/../spec_helper'
 
describe SurveyResponsesController do
  describe "create" do
    before do
      r = SurveyResponse.new
      SurveyResponse.should_receive(:new).and_return r
      r.should_receive(:set_answers!).with({'answers' => 'blah'})
      post :create, {answers: 'blah'}
    end
    specify { response.should redirect_to(complete_surveys_path) }
  end
end