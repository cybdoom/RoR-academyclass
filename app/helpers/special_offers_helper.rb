module SpecialOffersHelper
  
  
  def course_dates
    @dates = CourseDate.includes(:location).where("course_id=? AND start_date>=now()", @course.id).order('start_date').map \
      {|d| [course_date_option_text(d), d.id]}
  end
  
  def course_date_option_text(course_date)
    course_date.start_date.strftime('%d %B %Y') + " - " + course_date.location.name + seats_available(course_date)
  end
  
  def seats_available(course_date)
    course_date.seats_sold = 0 unless course_date.seats_sold
    return "" if course_date.total_seats.nil?
    return " (#{course_date.total_seats - course_date.seats_sold} seats available)"
  end
  
  def seats_for_sale(special_offer_course_date)
    qty = special_offer_course_date.seats_available
    return qty == 0 ? "Sold Out" : qty
  end  
end