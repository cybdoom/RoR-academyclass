module SurveysHelper
  def display_score(survey_question, option)
    return "#{survey_question.counts_for_option(option)} (#{survey_question.percentages_for_option(option).round}%)"
  end
  
  def respondent_name(response)
    response.name.nil? ? "Anonymous" : "#{response.name}#{response.company.blank? ? nil : " from #{response.company}"}"
  end
end