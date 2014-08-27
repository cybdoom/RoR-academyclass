module ProductsHelper

  def next_six_months
    6.times.map {|i| (Date.today >> i).strftime('%b') }
  end

  def course_dates?(course_id, location_id, month)
    course_locations_and_dates[course_id] && course_locations_and_dates[course_id][location_id] && course_locations_and_dates[course_id][location_id][month]
  end

  def course_locations_and_dates
    @course_dates ||= build_course_locations_and_dates
  end

  def product_courses
    @courses ||= Course.for_product_page(@product.id)
  end    

  def build_course_locations_and_dates
    # e.g. {course_id => [city => [month => [dates], month => [dates]]]}
    course_dates = {}
    CourseDate.future.find_all_by_product_id(@product.id).each do |cd|
      date = cd.start_date.strftime("%b")
      course_dates[cd.course_id] ||= {}
      course_dates[cd.course_id][cd.location_id] ||= {}
      course_dates[cd.course_id][cd.location_id][date] ||= []
      course_dates[cd.course_id][cd.location_id][date] << "#{cd.start_date.day} - #{cd.end_date.day}"
    end
    course_dates
  end

  def attachment_is_flash?(logo)
    return logo.url[-4..-1] == ".swf"
  end
end
