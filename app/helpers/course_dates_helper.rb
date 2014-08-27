module CourseDatesHelper
  def display_dates(course_date)
    return course_date.start_date.strftime("%d %b %Y") + " to " + course_date.end_date.strftime("%d %b %Y")
  end

  def show_course_cost(course)
    return "%0.02f" % course.cost if course.cost
    return "call"
  end
end