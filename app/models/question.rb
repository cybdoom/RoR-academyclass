class Question < ActiveRecord::Base
  validates_presence_of :question
  has_many :survey_questions
  has_many :answers, :through => :survey_questions
  default_scope :order => "section"
  
  before_validation do |q|
    q.section = nil if q.section.blank?
  end
  
  BOOLEAN = 1
  MULTICHOICE = 2
  FREE_TEXT = 3
  POOR_EXCELLENT = 4
  AGREE_DISAGREE = 5
  MULTICHOICE_AGREE_DISAGREE = 6
  
  def self.type_name(type)
    case type
      when BOOLEAN then return "Yes / No"
      when AGREE_DISAGREE then return "Agree / Disagree"
      when MULTICHOICE then return "Multichoice: 1 - 5"
      when POOR_EXCELLENT then return "Multichoice: Poor - Excellent"
      when MULTICHOICE_AGREE_DISAGREE then return "Multichoice: Disagree - Agree"
      when FREE_TEXT then return "Free text"
      else return "Unknown"
    end
  end

  def type_name
    Question.type_name(self.question_type)
  end
  
  def alternative_options
    return Question.build_question_options([BOOLEAN, AGREE_DISAGREE]) if boolean?
    return Question.build_question_options([MULTICHOICE, POOR_EXCELLENT, MULTICHOICE_AGREE_DISAGREE]) if multichoice?
    return Question.build_question_options([FREE_TEXT])
  end
  
  def self.type_options
    build_question_options [BOOLEAN, AGREE_DISAGREE, MULTICHOICE, POOR_EXCELLENT, MULTICHOICE_AGREE_DISAGREE, FREE_TEXT]
  end
  
  def self.build_question_options(types)
    types.map {|o| [Question.type_name(o), o]}
  end
  
  def options?
    return FREE_TEXT != question_type
  end
  
  def options
    case question_type
      when BOOLEAN then return [["Yes", 1], ["No", 0]]
      when AGREE_DISAGREE then return [["Agree", 1], ["Disagree", 0]]
      when MULTICHOICE then return (1..5).map {|i| [i,i]}.reverse
      when POOR_EXCELLENT then return [["Excellent",5], ["Above Average",4], ["Average",3], ["Below Average",2], ["Poor",1]]
      when MULTICHOICE_AGREE_DISAGREE then return [["Strongly Agree",5], ["Agree",4], ["Indifferent",3], ["Disagree",2], ["Strongly Disagree",1]]
    end
  end
  
  def boolean?
    return question_type == BOOLEAN || question_type == AGREE_DISAGREE
  end
  
  def multichoice?
    return question_type == MULTICHOICE || question_type == POOR_EXCELLENT || question_type == MULTICHOICE_AGREE_DISAGREE
  end
  
  def free_text?
    return question_type == FREE_TEXT
  end
end
