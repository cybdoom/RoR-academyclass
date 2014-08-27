class SurveyQuestionsController < ApplicationController
  before_filter :check_admin

  # called ajaxically
  def create
    survey_questions = []
    if params[:question_ids]
      questions = Question.find(params[:question_ids])
      questions.each do |question|
        q = SurveyQuestion.new({:question => question, :survey_id => params[:survey_id]})
        (survey_questions << q) if q.save
      end
    end
    render :json => {"questions" => survey_questions}
  end
  
  def update
    params.each do |object, order|
      if order.class == Array
        cl = SurveyQuestion.where(:survey_id => params[:survey])
        cl.each do |c|
          c.position = order.index(c.id.to_s)+1
          c.save
        end
        break
      end
    end
    render :nothing => true  
  end
end
