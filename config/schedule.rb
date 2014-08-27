# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/home/rails/academyclass/shared/log/cron.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
every 10.minutes do
  runner "Tweet.get_latest"
end

every 1.day, :at => "8:34pm" do
  rake 'qa:publish'
end

every :monday, at: '9am' do
  rake 'ac:course_export'
end
# every 1.day, :at => "4:00pm" do
#   runner "BookingDelegate.create_users"
# end