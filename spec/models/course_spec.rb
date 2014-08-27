require File.dirname(__FILE__) + '/../spec_helper'

describe 'Course' do

  describe 'for_product_page' do
    before do
      @product = FactoryGirl.create(:product)
      FactoryGirl.create(:course_product, product: @product, course: @course2 = FactoryGirl.create(:course), priority: 2)
      FactoryGirl.create(:course_product, product: @product, course: @course1 = FactoryGirl.create(:course), priority: 1)
    end
    specify { Course.for_product_page(@product.id).should == [@course1, @course2]}
  end
end