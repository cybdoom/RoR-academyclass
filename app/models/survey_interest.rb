class SurveyInterest < ActiveRecord::Base
  belongs_to :survey_response
  belongs_to :survey_product
  validates_presence_of :survey_response, :survey_product
end