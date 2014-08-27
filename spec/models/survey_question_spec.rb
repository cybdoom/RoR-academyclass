require File.dirname(__FILE__) + '/../spec_helper'
 
describe SurveyQuestion do

  describe "reporting" do
    before { @q = SurveyQuestion.new }
    describe "for binary question" do
      before { @q.answers = [Answer.new(:option => 0), Answer.new(:option => 1), Answer.new(:option => 0)] }
      describe "counts for option" do
        specify { @q.counts_for_option(0).should == 2 }
        specify { @q.counts_for_option(1).should == 1 }
        specify { @q.counts_for_option(2).should == 0 }
      end
      describe "percentages for option" do
        specify { @q.percentages_for_option(0).round.should == (200.0/3).round }
        specify { @q.percentages_for_option(1).round.should == (100.0/3).round }
        specify { @q.percentages_for_option(2).should == 0 }
      end
    end
    describe "for multichoice question" do
      before { @q.answers = [Answer.new(:option => 1), Answer.new(:option => 1), Answer.new(:option => 2), Answer.new(:option => 5), Answer.new(:option => 4)] }
      describe "counts for option" do
        specify { @q.counts_for_option(0).should == 0 }
        specify { @q.counts_for_option(1).should == 2 }
        specify { @q.counts_for_option(2).should == 1 }
        specify { @q.counts_for_option(3).should == 0 }
        specify { @q.counts_for_option(4).should == 1 }
        specify { @q.counts_for_option(5).should == 1 }
      end
      describe "percentages for option" do
        specify { @q.percentages_for_option(0).should == 0 }
        specify { @q.percentages_for_option(1).round.should == (200.0/5.0).round }
        specify { @q.percentages_for_option(2).round.should == (100.0/5.0).round }
        specify { @q.percentages_for_option(3).should == 0 }
        specify { @q.percentages_for_option(4).round.should == (100.0/5.0).round }
        specify { @q.percentages_for_option(5).round.should == (100.0/5.0).round }
      end
    end
  end
end
