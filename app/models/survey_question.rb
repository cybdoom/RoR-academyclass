class SurveyQuestion < ActiveRecord::Base
  belongs_to :survey
  belongs_to :question
  has_many :answers
  validates_presence_of :survey, :question
  after_destroy :remove_question_if_one_off
  default_scope :order => "position"
  
  before_validation :set_position, :on => :create

  scope :with_question, includes(:question)
  
  def set_position
    latest = SurveyQuestion.where(:survey_id => survey_id).select(:position).order("position DESC").first
    self.position = latest ? latest.position + 1 : 1
  end
  
  def as_json(options={})
    {:id => id, :survey_id => survey_id, :question_id => question.id, :question_text => question.question, :question_type => question.question_type, :section => question.section}
  end
  
  def remove_question_if_one_off
    question.destroy if question.one_off
  end
  
  def counts_for_option(option)
    count = 0
    answers.each do |a|
      count+=1 if a.option == option
    end
    count
  end
  
  def percentages_for_option(option)
    return 0 if answers.size == 0
    return (counts_for_option(option).to_f / answers.size.to_f) * 100
  end
end
