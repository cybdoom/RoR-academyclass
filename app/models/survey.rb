class Survey < ActiveRecord::Base
  has_many :survey_questions, :autosave => true
  has_many :survey_responses
  belongs_to :course_date
  validates_presence_of :name, :start_date, :end_date, :location
  attr_accessor :copy_questions_from
  
  before_save do |survey|
    survey.trainer = nil if survey.trainer.blank?
    if survey.copy_questions_from != nil && survey.copy_questions_from.to_i > 0
      copy = Survey.find(survey.copy_questions_from.to_i, :include => :survey_questions)
      copy.survey_questions.each do |q|
        survey.survey_questions.build({:question_id => q.question_id, :position => q.position})
      end
    end
  end
  
  def to_s
    s = "#{name} on #{start_date.strftime("%d %B %Y")}"
    s += " with #{trainer}" if trainer
    s += " (#{survey_questions.size} questions)"
    s
  end
end
