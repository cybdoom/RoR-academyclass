require File.dirname(__FILE__) + '/../spec_helper'
 
describe SurveyResponse do

  describe "set answers" do
    before do
      @q7 = FactoryGirl.build(:survey_question, :id => 7, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 1))
      @q8 = FactoryGirl.build(:survey_question, :id => 8, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 2))
      @q9 = FactoryGirl.build(:survey_question, :id => 9, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 3))
      @q10 = FactoryGirl.build(:survey_question, :id => 10, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 1))
      @q11 = FactoryGirl.build(:survey_question, :id => 11, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 1))
      @q12 = FactoryGirl.build(:survey_question, :id => 12, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 1))
      @q13 = FactoryGirl.build(:survey_question, :id => 13, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 2))
      @q14 = FactoryGirl.build(:survey_question, :id => 14, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 2))
      @q15 = FactoryGirl.build(:survey_question, :id => 15, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 2))
      @q16 = FactoryGirl.build(:survey_question, :id => 16, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 3))
      @q17 = FactoryGirl.build(:survey_question, :id => 17, :survey => nil, :question => FactoryGirl.build(:question, :question_type => 3))
      
      @r = SurveyResponse.new(:survey_id => 9)
      SurveyQuestion.should_receive(:with_question).and_return questions = [@q7, @q8, @q9, @q10, @q11, @q12, @q13, @q14, @q15, @q16, @q17]
      questions.should_receive(:find_all_by_survey_id).with(9).and_return questions
    end
    describe "with no existing answers" do
      before do
        @r.set_answers!({"10"=>"0", "11"=>"", "12"=>"1", "13"=>"4", "14" => "2", "15" => "", "16"=>"", "17"=>"here's a freetext answer"})
        @answers = {}
        @r.answers.each {|a| @answers[a.survey_question.id] = a.survey_question.question.free_text? ? a.answer : a.option }
      end
      specify { @answers.should == {10 => 0, 12 => 1, 13 => 4, 14 => 2, 17 => "here's a freetext answer"} }
    end
    describe "with existing answers" do
      before do
        answers = [FactoryGirl.build(:answer, :survey_response => @r, :survey_question => @q7, :option => 1, :answer => nil),
                   FactoryGirl.build(:answer, :survey_response => @r, :survey_question => @q8, :option => 3, :answer => nil),
                   FactoryGirl.build(:answer, :survey_response => @r, :survey_question => @q10, :option => 1, :answer => nil),
                   FactoryGirl.build(:answer, :survey_response => @r, :survey_question => @q11, :option => 1, :answer => nil),
                   FactoryGirl.build(:answer, :survey_response => @r, :survey_question => @q13, :option => 2, :answer => nil),
                   FactoryGirl.build(:answer, :survey_response => @r, :survey_question => @q14, :option => 3, :answer => nil),
                   FactoryGirl.build(:answer, :survey_response => @r, :survey_question => @q16, :answer => "here's an answer which gets removed")]
        @r.answers = answers
        @r.set_answers!({"10"=>"0", "11"=>"", "12"=>"1", "13"=>"4", "14" => "2", "15" => "", "16"=>"", "17"=>"here's a freetext answer"})
        @answers = {}
        @r.answers.each {|a| @answers[a.survey_question.id] = a.survey_question.question.free_text? ? a.answer : a.option }
      end
      specify { @answers.should == {10 => 0, 12 => 1, 13 => 4, 14 => 2, 17 => "here's a freetext answer"} }
    end
  end
end
