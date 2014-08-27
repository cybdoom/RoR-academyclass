require File.dirname(__FILE__) + '/../spec_helper'
 
describe CourseDate do
  describe "find by course location date" do
    before do
      @course = FactoryGirl.create(:course, :name => "Ima course")
      @location = FactoryGirl.create(:location, :name => "Auckland")
      @date1 = FactoryGirl.create(:course_date, :location => @location, :course => @course, :start_date => "2010-12-15", end_date: '2010-12-16')
      @date2 = FactoryGirl.create(:course_date, :location => @location, :course => @course, :start_date => "2010-12-17", end_date: '2010-12-19')
    end
    specify { CourseDate.find_by_course_location_date("Ima course", "Auckland", "2010-12-15").should == @date1 }
    specify { CourseDate.find_by_course_location_date("Ima course", "Auckland", "2010-12-16").should == @date1 }
    specify { CourseDate.find_by_course_location_date("Ima course", "Auckland", "2010-12-17").should == @date2 }
    specify { CourseDate.find_by_course_location_date("Im a course", "Auckland", "2010-12-15").should == @date1 }
    specify { CourseDate.find_by_course_location_date("Ima course", "Duckland", "2010-12-15").should be_nil }
  end
end