class SurveyResponsesController < ApplicationController
  before_filter :check_admin, :except => [:create, :complete]
  layout "admin"
  
  def index
    @survey = Survey.find(params[:survey])
    @survey_questions = SurveyQuestion.all(:conditions => {:survey_id => @survey.id}, :include => [{:answers => :survey_response},:question])
    @survey_responses = SurveyResponse.all(:conditions => {:survey_id => @survey.id}, :include => {:survey_interests => :survey_product})
  end
  
  def create
    @survey_response = SurveyResponse.new(params[:survey_response])
    @survey_response.set_answers!(params.reject{|k,v| k == 'controller' || k == 'action'})
    redirect_to complete_surveys_path
  end
end
