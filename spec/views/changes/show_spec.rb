require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/changes/show.html.erb" do
  include ChangesHelper
  fixtures :apps, :activities

  before(:each) do
    @app = apps(:app_1)

    @activity = activities(:app_1_dev)
    @activity.stub!(:app).and_return(@app)

    assigns[:activity] = @activity
    
    @change = mock_model(Change)
    @change.stub!(:dba).and_return("dba1@example.com")
    @change.stub!(:developer).and_return("developer1@example.com")
    @change.stub!(:sql).and_return("sql")
    @change.stub!(:state).and_return("executed")
    @change.stub!(:created_at).and_return(Time.zone.now)
    @change.stub!(:activity).and_return(@activity)

    assigns[:change] = @change 
  end

  it "should render attributes in <p>" do
    render "/changes/show.html.erb"
    response.should have_text(/dba1@example.com/)
    response.should have_text(/developer1@example.com/)
    response.should have_text(/sql/)
    response.should have_text(/executed/)
  end
end

