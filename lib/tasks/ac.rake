namespace :ac do

  def generate_date_csv
    CSV.open(Rails.root.join('dates.csv'), 'wb') do |csv|
      csv << ["Course", "Location", "Start Date", "Seats", "Sold"]
      CourseDate.future.includes(:location, :course).each do |d|
        csv << [d.course.name, d.location.name, d.start_date.strftime('%d %B %Y'), d.total_seats, d.seats_sold]
      end
    end
  end

  def email_date_csv
    SiteMailer.date_csv_email('dates.csv').deliver
  end

  def delete_date_csv
    File.delete(Rails.root.join('dates.csv'))
  end

  task :course_export => :environment do
    generate_date_csv()
    email_date_csv()
    delete_date_csv()
  end
end