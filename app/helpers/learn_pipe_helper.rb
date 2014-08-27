module LearnPipeHelper
  def course_level(level)
    @learn_pipe_levels ||= %w(N/A Beginner Intermediate Advanced)
    @learn_pipe_levels.include?(level) ? level : "Beginner"
  end
end