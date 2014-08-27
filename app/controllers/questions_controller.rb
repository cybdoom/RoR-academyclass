class QuestionsController < ApplicationController
  before_filter :check_admin
  layout "admin"
  
  def index
    @questions = Question.includes({:survey_questions => :question})
  end
  
  def show
    @question = Question.includes(:answers => :survey_response).find(params[:id])
  end
  
  def destroy
    @question = Question.find(params[:id])
    @question.destroy if @question.survey_questions.empty?
    redirect_to questions_path
  end
  
  # called ajaxically
  def create
    @survey = Survey.find(params[:survey])
    @question = Question.new(params[:question])
    if @question.save
      @survey_question = SurveyQuestion.create(:survey => @survey, :question => @question)
      render :json => @survey_question.to_json
    else
      render :json => {:error => @question.errors.join("\n")}.to_json
    end
  end
  
  # called ajaxically
  def update
    @question = Question.find(params[:id])
    @question.attributes = params[:question]
    @question.save
    respond_to do |t|
      t.js { render :nothing => true }
      t.html { redirect_to questions_path }
    end
  end
end
