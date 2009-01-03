require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/index.html.erb" do
  include ActivitiesHelper
  fixtures :apps
  
  before(:each) do
    @app = apps(:app_1)
    assigns[:app] = @app
    
    activity_98 = mock_model(Activity)
    activity_98.should_receive(:to_s).twice.and_return("Activity Name")
    activity_98.should_receive(:description).and_return("Description")
    activity_98.should_receive(:state).at_least(:once).and_return("State")
    activity_98.should_receive(:app).and_return(@app)
    
    activity_99 = mock_model(Activity)
    activity_99.should_receive(:to_s).twice.and_return("Activity Name")
    activity_99.should_receive(:description).and_return("Description")
    activity_99.should_receive(:state).at_least(:once).and_return("State")
    activity_99.should_receive(:app).and_return(@app)

    assigns[:activities] = [activity_98, activity_99]
    
    new_activity = mock_model(Activity, :null_object => true)
    assigns[:activity] = new_activity
  end

  it "should render list of activities" do
    render "/activities/index.html.erb"
    response.should have_tag("tr>td", "Activity Name", 2)
    response.should have_tag("tr>td", "Description", 2)
    response.should have_tag("tr>td", "State", 2)
  end
end

