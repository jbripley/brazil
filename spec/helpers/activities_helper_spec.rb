require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivitiesHelper do

  it "should call activity_author and return dba" do
    dba = 'dba1@example.com'

    change = mock_model(Change)
    change.stub!(:dba).and_return(dba)

    changes = mock(Array)
    changes.stub!(:first).and_return(change)

    activity = mock_model(Activity)
    activity.stub!(:changes).and_return(changes)

    helper.activity_author(activity).should == dba
  end

  describe "when calling actionable_count" do

    before(:each) do
      @activity = mock_model(Activity)
    end

    describe "and count changes in state Change::STATE_SUGGESTED for activities in state Activity::STATE_DEVELOPMENT" do

      before(:each) do
        @suggested_count = 3

        @changes = mock(Array)
        @changes.stub!(:count).and_return(@suggested_count)

        @activity.stub!(:state).and_return(Activity::STATE_DEVELOPMENT)
        @activity.stub!(:changes).and_return(@changes)
      end

      it "should be in html format" do
        helper.activity_actionable_count(@activity).should == "(<abbr title=\"#{@suggested_count} Suggested\">#{@suggested_count}</abbr>)"
      end

      it "should be in a format usable by atom" do
        helper.activity_actionable_count(@activity, :atom).should == "(#{@suggested_count})"
      end
    end

    describe "and count versions in state Version::STATE_CREATED and Version::STATE_TESTED for activities in state Activity::STATE_DEPLOYED" do

      before(:each) do
        @version_state_counts = [[Version::STATE_CREATED, 1], [Version::STATE_TESTED, 1]]

        @versions = mock(Array)
        @versions.stub!(:count).and_return(@version_state_counts)

        @activity.stub!(:state).and_return(Activity::STATE_DEPLOYED)
        @activity.stub!(:versions).and_return(@versions)
      end

      it "should be in html format" do
        helper.activity_actionable_count(@activity).should == "(<abbr title=\"#{@version_state_counts[0][1]} #{@version_state_counts[0][0].capitalize}\">#{@version_state_counts[0][1]}</abbr>, <abbr title=\"#{@version_state_counts[1][1]} #{@version_state_counts[1][0].capitalize}\">#{@version_state_counts[1][1]}</abbr>)"
      end

      it "should be in a format usable by atom" do
        helper.activity_actionable_count(@activity, :atom).should == "(#{@version_state_counts[0][1]}, #{@version_state_counts[1][1]})"
      end
    end

  end

end
