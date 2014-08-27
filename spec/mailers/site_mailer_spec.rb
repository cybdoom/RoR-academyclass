require File.dirname(__FILE__) + '/../spec_helper'
 
describe SiteMailer do

  def course_email(course, name, email)
    @course = course
    @name = name
    mail(:subject => "Academy Class Course Details: #{course.name}", :to => recipient_address("#{name} <#{email}>"))
  end

  describe 'course_email' do
    before do
      @course = Course.new(name: 'PHP Development 101')
      @email = SiteMailer.course_email(@course, "johnny", "johnny@hotmail.com").deliver
    end
    specify { @email.to_addrs.join.should == "johnny@hotmail.com" }
    specify { @email.parts.first.should include_text('PHP Development 101') }
    specify { @email.parts.second.should include_text('PHP Development 101') }
  end
end