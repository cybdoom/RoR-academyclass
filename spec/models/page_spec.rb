require File.dirname(__FILE__) + '/../spec_helper'
 
describe Page do
  it "should validate the name" do
    FactoryGirl.build(:page, :name => nil).should_not be_valid
    FactoryGirl.build(:page, :name => "Joe").should be_valid
  end
end
