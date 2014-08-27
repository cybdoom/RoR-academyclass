xml.instruct!
xml.manufacturers do
  @manufacturers.each do |manufacturer|
    xml.manufacturer do
      xml.manufacturer_name manufacturer.name
      xml.products do
        manufacturer.products.each do |product|
          xml.product do
            xml.product_name product.name
            xml.courses do
              product.courses.each do |course|
                if course.publish_xml
                  xml.course do
                    xml.id course.id
                    xml.name course.name
                    xml.description textilize(course.description)
                    xml.level course.level
                    xml.cost show_course_cost(course)
                    xml.who_for textilize(course.who_for)
                    xml.assumed_knowledge textilize(course.assumed_knowledge)
                    xml.you_will_learn textilize(course.you_will_learn)
                    xml.image "http://#{request.host_with_port}#{course.logo.url}" if course.logo
                    xml.outline textilize(course.outline)
                    xml.course_dates do
                      course.course_dates.each do |date|
                        if date.start_date > Date.today
                          xml.course_date do
                            xml.location date.location.name
                            xml.start_date date.start_date
                            xml.end_date date.end_date
                          end
                        end
                      end
                    end
                  end
                 end
              end
            end
          end
        end
      end
    end
  end
end
