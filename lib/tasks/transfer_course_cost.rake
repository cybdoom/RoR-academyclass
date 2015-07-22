namespace :transfer do
  desc "Transfer course cost"
  task :course_cost => :environment do
    puts "Start transfer"
    Course.all.each do |c|
      if c.cost
      	new_cost = c.cost.to_s.gsub!(".00", "")
        sql = "UPDATE courses SET cost = '#{new_cost}' WHERE courses.id = '#{c.id}'"
        ActiveRecord::Base.connection.execute(sql)
        puts c.cost.to_s + "\n"
      end
    end
  end
end