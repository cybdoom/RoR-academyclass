class Answer < ActiveRecord::Base
  belongs_to :survey_question
  belongs_to :survey_response
  
  def self.counts_by_trainer(question_id)
    Answer.counts_by_sql "SELECT trainer AS value, a.option, count(*) AS count FROM surveys s
      INNER JOIN survey_questions sq ON sq.survey_id=s.id
      INNER JOIN answers a ON sq.id=a.survey_question_id
      WHERE sq.question_id=#{question_id.to_i} GROUP BY trainer, a.option ORDER BY count DESC"
  end
  
  def self.counts_by_location(question_id)
    Answer.counts_by_sql "SELECT location AS value, a.option, count(*) AS count FROM surveys s
      INNER JOIN survey_questions sq ON sq.survey_id=s.id
      INNER JOIN answers a ON sq.id=a.survey_question_id
      WHERE sq.question_id=#{question_id.to_i} GROUP BY location, a.option ORDER BY count DESC"
  end
  
  def self.counts_by_course(question_id)
    Answer.counts_by_sql "SELECT name AS value, a.option, count(*) AS count FROM surveys s
      INNER JOIN survey_questions sq ON sq.survey_id=s.id
      INNER JOIN answers a ON sq.id=a.survey_question_id
      WHERE sq.question_id=#{question_id.to_i} GROUP BY name, a.option ORDER BY count(*) DESC"
  end

  def self.counts_by_sql(sql)
    counts = {}
    Answer.connection.select_all(sql).each do |a|
      counts[a["value"]] = {} unless counts[a["value"]]
      counts[a["value"]][a["option"].to_i] = a["count"].to_i
    end
    counts
  end
end
