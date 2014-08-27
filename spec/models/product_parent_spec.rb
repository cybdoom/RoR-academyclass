require File.dirname(__FILE__) + '/../spec_helper'
 
describe ProductParent do
  describe 'with courses' do
    before { @parent = FactoryGirl.create(:course_product).product.product_parent }
    specify { ProductParent.with_courses.should == [@parent] }
  end

  describe 'with_dates_and_locations' do
    before do
      date = FactoryGirl.create(:course_date)
      @parent = FactoryGirl.create(:course_product, course: date.course).product.product_parent
    end
    specify { ProductParent.with_dates_and_locations.should == [@parent] }
  end

  describe 'with_dates_and_locations' do
    before do
      date1 = FactoryGirl.create(:course_date, start_date: Date.today + 1, end_date: Date.today + 4)
      @parent1 = FactoryGirl.create(:course_product, course: date1.course).product.product_parent
      date2 = FactoryGirl.create(:course_date, start_date: Date.today, end_date: Date.today + 3)
      @parent2 = FactoryGirl.create(:course_product, course: date2.course).product.product_parent
    end
    specify { ProductParent.with_dates_and_locations.after_today.should == [@parent1] }
  end
end