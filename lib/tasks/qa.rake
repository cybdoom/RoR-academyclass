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
            "Price" => date.course.cost.gsub(/[^0-9\.]+/, '').to_f,
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