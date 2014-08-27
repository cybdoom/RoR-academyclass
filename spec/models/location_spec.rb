require File.dirname(__FILE__) + '/../spec_helper'
 
describe Location do
  
  describe "postcode" do
    before do
      @location = FactoryGirl.build(:location, :address => "1234 Someplace St\nLondon\nSE2 3ER")
    end
    subject { @location.postcode }
    it { should == "SE2 3ER"}
    describe "town" do
      subject { @location.postcode_town }
      it { should == "SE" }
    end
  end
  
    
end