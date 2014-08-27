require File.dirname(__FILE__) + '/../spec_helper'
 
describe ProductsHelper do

  describe 'next_six_months' do
    before { Date.should_receive(:today).exactly(6).times.and_return Date.new(2013, 10, 14) }
    specify { next_six_months.should == ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'] }
  end

  describe "build_course_locations_and_dates" do
    before do
      @product = double('Product', id: 12)

      @dates = [
        CourseDate.new(location_id: 11, start_date: Date.new(2020,12,12), end_date: Date.new(2020,12,14), course_id: 1),
        CourseDate.new(location_id: 12, start_date: Date.new(2020,12,12), end_date: Date.new(2020,12,14), course_id: 1),
        CourseDate.new(location_id: 12, start_date: Date.new(2020,12,16), end_date: Date.new(2020,12,18), course_id: 1),
        CourseDate.new(location_id: 13, start_date: Date.new(2020,12,16), end_date: Date.new(2020,12,18), course_id: 2)
      ]
      CourseDate.should_receive(:future).and_return @dates
      @dates.should_receive(:find_all_by_product_id).with(12).and_return @dates
    end
    specify { build_course_locations_and_dates.should == {
      1 => { 11 => {"Dec" => ["12 - 14"]}, 12 => {"Dec" => ["12 - 14", "16 - 18"]}},
      2 => { 13 => {"Dec" => ["16 - 18"]}},
    } }
  end

  describe 'attachment_is_flash' do
    specify { attachment_is_flash?(double(url: '/something.swf')).should be_true }
    specify { attachment_is_flash?(double(url: '/something.gif')).should be_false }
    specify { attachment_is_flash?(double(url: '/something.jpg')).should be_false }
  end

  describe 'product_courses' do
    before do
      @product = double('Product', id: 12)
      Course.should_receive(:for_product_page).with(12).and_return 'courses'
    end
    specify { product_courses.should == 'courses' }
  end
end