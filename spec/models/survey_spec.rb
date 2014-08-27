require File.dirname(__FILE__) + '/../spec_helper'
 
describe Survey do

  describe "save" do
    describe "new" do
      before { @survey = FactoryGirl.build(:survey, :trainer => "") }
      describe "set trainer name to nil" do
        before { @survey.save }
        specify { @survey.trainer.should be_nil }
      end
      describe "copy survey" do
        before do
          @copy = FactoryGirl.create(:survey)
          @q1 = FactoryGirl.create(:question)
          @q2 = FactoryGirl.create(:question)
          @copy.survey_questions.create(:question => @q1, :position => 1)
          @copy.survey_questions.create(:question => @q2, :position => 2)
          @survey.copy_questions_from = @copy.id
          @survey.save!
        end
        specify { @survey.reload.survey_questions.map {|q|{q.position => q.question}}.should == [{1 => @q1}, {2 => @q2}] }
      end
    end
  end
end
