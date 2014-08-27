class SurveyResponse < ActiveRecord::Base
  has_many :answers, :autosave => true, :dependent => :delete_all
  has_many :survey_interests
  has_many :survey_products, :through => :survey_interests
  belongs_to :survey
  validates_presence_of :survey
  accepts_nested_attributes_for :survey_interests
  
  before_validation do |r|
    r.name = nil if r.blank?
    r.company = nil if r.blank?
  end
  
  def anonymous?
    return name.nil? || (name.blank? && company.blank?)
  end

  # takes a hash of question IDs (keys) and answers (values)
  def set_answers!(params)
    SurveyQuestion.with_question.find_all_by_survey_id(survey_id).each do |question| # iterate through all survey questions
      if params[question.id.to_s].blank? # if the question hasn't been answered
        remove_answer(question.id)
      else
        set_answer(question, params[question.id.to_s]) # save the answer
      end
    end
    save
  end
  
  private
  
  def set_answer(survey_question, value)
    answer = find_answer(survey_question.id) || self.answers.build(:survey_question => survey_question)
    if survey_question.question.free_text?
      answer.answer = value
    else
      answer.option = value
    end
  end
  
  # destroy the answer if it exists (the user has unset it in the form)
  def remove_answer(question_id)
    answers.each do |a|
      if a.survey_question.id == question_id
        self.answers.delete(a)
        a.destroy 
        return
      end
    end
  end
  
  def find_answer(question_id) 
    answers.each {|a| return a if a.survey_question_id == question_id }
    nil
  end
end