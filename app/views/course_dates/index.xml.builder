xml.instruct!
xml.schedule "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @courses.each do |course|
    xml.course(:id => course.id, :name => course.name) do
      course.course_dates.each do |date|
        if !@current || date.current?
          xml.schedule(:price => show_course_cost(course)) do
            xml.location date.location.name
            xml.start_date date.start_date
            xml.end_date date.end_date
          end
        end
      end
    end
  end
end
