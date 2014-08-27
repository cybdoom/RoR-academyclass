require 'rubygems'
require 'mysql'
require "cgi"
require 'net/http'


class Hash
  def to_query(namespace = nil)
    collect do |key, value|
      value.to_query(namespace ? "#{namespace}[#{key}]" : key)
    end.sort * '&'
  end
end

class Array
  def to_query(key)
    prefix = "#{key}[]"
    collect { |value| value.to_query(prefix) }.join '&'
  end
end

class Object
  def to_query(key)
    require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
    "#{CGI.escape(key.to_s).gsub(/%(5B|5D)/n) { [$1].pack('H*') }}=#{CGI.escape(to_s)}"
  end
end

SERVER_API_HOST = "www.academyclass.com"
SERVER_API_PORT = "80"
# SERVER_API_HOST = "localhost"
# SERVER_API_PORT = "3000"
SERVER_API_PATH = "/set_course_seats"
SERVER_LOGIN_PARAMS = "username=api&password=fa1e4a3604b6f170c2f3413de077d94d9c146c4fa484611b4f6a1abda11ac848f2a46faa3dde13fd6bbe80e383d8f6bea0783da7631917411d868683003f89e1"

def send_course(name, location, start_date, total_seats, seats_sold)
  params = {:name => name.gsub(/\226/, "-"), :location => location, :start_date => start_date, :total_seats => total_seats, :seats_sold => seats_sold}
  puts "Updating course #{name} with total seats: #{total_seats}, seats sold: #{seats_sold}"
  response = Net::HTTP.post_form(URI.parse("http://#{SERVER_API_HOST}:#{SERVER_API_PORT}/set_course_seats?#{SERVER_LOGIN_PARAMS}"), params)
  result = response.body.to_s.strip
  success = (response.class == Net::HTTPOK)
  puts success ? "#{Time.now} Successfully transmitted course details for course date #{start_date}: #{result}" : "#{Time.now} Error transmitting course date #{start_date}: #{result}"

  @mysql.query("INSERT INTO course_logs (created_at, name, location, start_date, total_seats, seats_sold, success, message) VALUES (now(), '#{@mysql.quote(name)}', '#{@mysql.quote(location)}', '#{start_date}', #{total_seats}, #{seats_sold}, #{success ? 1 : 0}, '#{@mysql.quote(result)}')")
  return success
end

@mysql = Mysql.init()
@mysql.connect('localhost', 'academyclass', '9xN3,oad4', 'academyclass_courses')

success_ids = []
@mysql.query("SELECT id, name, location, DATE_FORMAT(start_date, '%Y-%m-%d'), total_seats, seats_sold FROM course_seats").each do |row|
  success_ids << row[0] if send_course(row[1], row[2], row[3], row[4], row[5])
end

if success_ids.size > 0
  @mysql.query("DELETE FROM course_seats WHERE id IN (#{success_ids.join(",")})")
end

def send_booking_form(form, delegates)
  params = {:booking_form => {:filemaker_code => form[1], :booking_type => form[2], :contact_name => form[3], \
    :email => form[4], :telephone => form[5], :company => form[6], :address => form[7], :postcode => form[8], \
    :salesperson => form[9], :vat_rate => form[10], :allow_invoice => form[11], :first_payment_date => form[13], \
    :lsm => form[14], :payment_count => form[15], :delegates_attributes => []} \
  }
  params[:username] = "api"
  params[:password] = "fa1e4a3604b6f170c2f3413de077d94d9c146c4fa484611b4f6a1abda11ac848f2a46faa3dde13fd6bbe80e383d8f6bea0783da7631917411d868683003f89e1"
  delegates.each do |d|
    vals = {:name => d[1], :course_name => d[2], :course_location => d[3], :start_date => d[4], :end_date => d[5], :price => d[7], :booking_type => d[8], :email => d[9]}
    vals[:platform_pc] = d[6] if d[6] == "0" || d[6] == "1"
    params[:booking_form][:delegates_attributes] << vals
  end
  puts "#{Time.now} Sending booking form for #{form[3]}: #{params.inspect}"
  response = Net::HTTP.start(SERVER_API_HOST, SERVER_API_PORT) do |http|
    url = "/booking_forms"
    http.post(url, params.to_query)
  end
  result = response.body
  success = (response.class == Net::HTTPOK)
  puts success ? "#{Time.now} Successfully transmitted booking form #{form[1]}" : "#{Time.now} Error transmitting booking form #{form[1]}: #{response.inspect}"

  @mysql.query("INSERT INTO booking_logs (created_at, filemaker_code, success, message) VALUES (now(), '#{@mysql.quote(form[1])}', #{success}, '#{@mysql.quote(response.class.name)}')")
  if success
    @mysql.query("DELETE FROM booking_form WHERE filemaker_code ='#{form[1]}'")
    puts "DELETE FROM booking_delegate WHERE booking_form_id ='#{form[1]}'"
    @mysql.query("DELETE FROM booking_delegate WHERE booking_form_id ='#{form[1]}'")
  end
  return success 
end

@mysql.query("SELECT id, filemaker_code, booking_type, contact_name, email, telephone, company, address, postcode, salesperson, vat_rate, allow_invoice, po_number, DATE_FORMAT(first_payment_date, '%Y-%m-%d'), lsm, payments FROM booking_form").each do |form|
  delegates = @mysql.query("SELECT id, name, course_name, course_location, DATE_FORMAT(start_date, '%Y-%m-%d'), DATE_FORMAT(end_date, '%Y-%m-%d'), platform_pc, price, booking_type, email FROM booking_delegate WHERE booking_form_id='#{form[1]}'")
  send_booking_form(form, delegates)
end

@mysql.close()
