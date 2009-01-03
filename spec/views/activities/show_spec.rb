require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/show.html.erb" do
  include ActivitiesHelper
  fixtures :apps, :activities
  
  before(:each) do
    @app = apps(:app_1)
    assigns[:app] = @app
    
    @activity = activities(:app_1_dev)
    @activity.should_receive(:app).at_least(:once).and_return(@app)
    
    @change = mock_model(Change)
    @change.stub!(:id).and_return(nil)
    @change.stub!(:new_record?).and_return(true)
    @change.stub!(:sql).and_return('')
    @change.stub!(:dba).and_return('')
    @change.stub!(:developer).and_return('')
    @change.stub!(:activity).and_return(@activity)
    
    errors = mock(Hash)
    errors.stub!(:count).and_return(0)
    @change.stub!(:errors).and_return(errors)
    
    assigns[:change] = @change

    assigns[:activity] = @activity
  end

  it "should render attributes in <p>" do
    render "/activities/show.html.erb"
    response.should have_text(/Activity\ 1\ Development/)
    response.should have_text(/brazil\_dev/)
    response.should have_text(/development/)
  end
end

