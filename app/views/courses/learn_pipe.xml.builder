xml.instruct!
xml.courses do
  @courses.each do |course|
    xml.course do
      xml.courseName {xml.cdata! course.name}
      xml.courseCode course.id
      xml.courseSubject {xml.cdata! course.products.first.name unless course.products.empty?} #the first product is the best we can do
      xml.courseLevel course_level(course.level)
      xml.keyword {xml.cdata! course.products.first.name unless course.products.empty?} #the first product is the best we can do
      # xml.keywords 
      xml.currency "GBP"
      xml.courseDelivery do
        xml.deliveryMethod "(Public) Instructor Led Classroom Based"
        xml.maskPrice false
        xml.price course.cost || 0
      end
      # xml.courseOutline #doesn't map requires a URL to a PDF
      xml.durationDays course.duration #currently an integer value in the databae so we are good
      # xml.durationHours #doesn't map
      xml.courseAudience {xml.cdata! course.who_for}
      xml.coursePrerequisites {xml.cdata! course.assumed_knowledge}
      # xml.courseObjectives #doesn't map
      xml.courseDesc {xml.cdata! course.description}
      xml.courseContent {xml.cdata! course.outline}
      xml.courseSkills {xml.cdata! course.you_will_learn}
      # xml.courseFollowUp #doesn't map
      course.course_dates.each do |date|
        xml.schedule do
          xml.delivery "(Public) Instructor Led Classroom Based"
          xml.startDate date.start_date
          xml.endDate date.end_date
          # xml.maxPlaces
          # xml.bookedPlaces
          # xml.requiredPlaces
          # xml.discount
          xml.venue do
            xml.addrName date.location.title
            # xml.addrDesc
            # xml.addrLineOne
            # xml.addrLineTwo
            xml.addrCity date.location.name
            # xml.addrProvince
            # xml.addrPostCode
            # xml.addrCountry
            xml.addrPhone "0800 043 8889"
            xml.addrEmail "training@academyclass.com"
          end
        end
      end
    end
  end
end