xml.instruct!
xml.root("xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:noNamespaceSchemaLocation" => "http://www.coursesplus.co.uk/course_feed.xsd") do
  @courses.each do |course|
    xml.course do
      xml.supplier @supplier
      xml.title course.name
      xml.description textilize(course.description)
      xml.details textilize(course.outline)
      xml.delivery 6
      xml.price display_cost_plaintext(course)
      xml.infolink "http://www.academyclass.com#{course.url}"
      xml.areas do
        if @locations[course.id]
          @locations[course.id].each do |location|
            xml.area location.postcode_town
          end
        end
      end
    end
  end
end
