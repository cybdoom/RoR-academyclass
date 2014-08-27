#GUID = "00cf4886-3c85-40c0-aa51-2cc846ad72ac"
GUID = "dc169588-43e6-4976-be93-30f58e982fac"
SharedSecret = "Acad3myC1a55"

namespace :qa do

  def client
    @client ||= Savon.client('https://psp.qa.com/WebServices/PSPUploads/PSPUploadService.svc?wsdl')
    @client.http.auth.ssl.verify_mode = :none
    @client
  end

  task :publish_courses => :environment do

    Savon.configure do |config|
      config.env_namespace = :soap
    end

    Course.where({:publish_xml => true}).each do |course|
      params = {"CourseCode" => course.id.to_s, 
        "Overview" => Textilizer.new(course.overview || "").to_html,
        "Prerequisites" => Textilizer.new(course.assumed_knowledge || "").to_html,
        "Objectives" => Textilizer.new(course.you_will_learn || "").to_html,
        "Outline" => Textilizer.new(course.outline || "").to_html,
        "TrainingProviderGUID" => GUID,
        "SharedSecret" => SharedSecret,
        :order! => %w(TrainingProviderGUID SharedSecret CourseCode Overview Prerequisites Objectives Outline),
        :attributes! => { "TrainingProviderGUID" => { "xmlns:q1" => "http://microsoft.com/wsdl/types/" } }

      }

      begin
        response = client.request :upload_course_overview, :xmlns => "http://psp.qa.com/" do
          soap.body = params
        end
      rescue Savon::SOAP::Fault => fault
        puts "SOAP fault"
        puts fault.inspect
        puts fault.to_s
      end
    end
  end

  task :publish_dates => :environment do

    Savon.configure do |config|
      config.env_namespace = :soap
    end

    dates = CourseDate.joins(:course).includes(:location, :course => {:products => :product_parent})\
      .where("courses.publish_xml = 1 AND course_dates.start_date > NOW() AND course_dates.total_seats IS NOT NULL")
    events = []
    dates.each do |date|

      unless date.course.products.empty?
        puts "Sending ID #{date.id.to_s} course #{date.course.name} (#{date.course_id.to_s}) location #{date.location.name} dates #{date.start_date.strftime("%Y-%m-%dT09:30:00")} - #{date.end_date.strftime("%Y-%m-%dT16:30:00")}"

        events << \
        {"Course" => 
          {"Code" => date.course_id.to_s, 
            "Start" => date.start_date.strftime("%Y-%m-%dT09:30:00"),
            "End" => date.end_date.strftime("%Y-%m-%dT16:30:00"),
            "ID" => date.id.to_s,
            "Location" => date.location.name,
            "Price" => date.course.cost,
            "Currency" => "GBP",
            "Vendor" => date.course.products.first.product_parent.name,
            "Title" => date.course.name,
            "Language" => "en-GB",
            "Spaces" => date.seats_available,
            "Category" => date.course.qa_category,
            :order! => %w(Code Start End ID Location Language Price Currency Vendor Title Spaces Category)
          }
        }
      end
    end


#<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:tns="http://psp.qa.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#<soap:Body><tns:UploadCoursesStandard xmlns="http://psp.qa.com/"><request><TrainingProviderGUID>dc169588-43e6-4976-be93-30f58e982fac</TrainingProviderGUID><SharedSecret>Acad3myC1a55</SharedSecret><Courses><Course><Code>198</Code><Start>2012-07-30T09:30:00</Start><End>2012-08-01T16:30:00</End><ID>12979</ID><Location>London</Location><Language>en-GB</Language><Price>697.0</Price><Currency>GBP</Currency><Vendor>Adobe</Vendor><Title>Indesign 301: Super Hot Shot</Title><Spaces>10</Spaces><Category>Adobe (BA)</Category></Course></Courses></request></tns:UploadCoursesStandard></soap:Body></soap:Envelope>

#<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
#<soap:Body><UploadCoursesStandard     xmlns="http://psp.qa.com/"><request><TrainingProviderGUID>dc169588-43e6-4976-be93-30f58e982fac</TrainingProviderGUID><SharedSecret>Acad3myC1a55</SharedSecret><Courses><Course><Code>7052</Code><Start>2012-07-30T09:00:00</Start><End>2012-07-31T17:30:00</End><ID>4132985</ID><Location>827</Location><Language>en-GB</Language><Price>390.00</Price><Currency>GBP</Currency><Vendor>Microsoft</Vendor><Title>M10778 for Vinci</Title><Spaces>1</Spaces><Category /></Course><Course><Code>M6425</Code><Start>2012-07-30T09:00:00</Start><End>2012-08-03T16:30:00</End><ID>4132214</ID><Location>827</Location><Language>en-GB</Language><Price>1750.00</Price><Currency>GBP</Currency><Vendor>Microsoft</Vendor><Title>Configuring and Troubleshooting Windows Server 2008 Active Directory Domain Services</Title><Spaces>3</Spaces><Category>Microsoft (IT)</Category></Course></Courses></request></UploadCoursesStandard></soap:Body></soap:Envelope>

    params = {
      :request => {
        "TrainingProviderGUID" => GUID,
        "SharedSecret" => SharedSecret,
        "Courses" => events,
        :order! => %w(TrainingProviderGUID SharedSecret Courses)
      }
    }      
    response = client.request :upload_courses_standard, :xmlns => "http://psp.qa.com/" do
      soap.body = params
    end
  end

  task :publish => [:environment, :publish_courses, :publish_dates] do
	end
end


#<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><UploadCourseOverview xmlns="http://psp.qa.com/"><TrainingProviderGUID>dc169588-43e6-4976-be93-30f58e982fac</TrainingProviderGUID><SharedSecret>Acad3myC1a55</SharedSecret><CourseCode>1</CourseCode><Overview>ttt</Overview><Prerequisites>tttt</Prerequisites><Objectives>tttt</Objectives><Outline>tttt</Outline></UploadCourseOverview></soap:Body></soap:Envelope>