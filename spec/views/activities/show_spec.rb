require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/show.html.erb" do
  include ActivitiesHelper
  
  before(:each) do
    @app = mock_model(App)
    assigns[:app] = @app
    
    @activity = mock_model(Activity)
    @activity.stub!(:name).and_return("Activity 1 Development")
    @activity.stub!(:description).and_return("MyString")
    @activity.stub!(:schema).and_return("brazil_dev")
    @activity.stub!(:state).and_return("development")
    @activity.stub!(:app_id).and_return("1")
    @activity.stub!(:development?).and_return(true)
    @activity.stub!(:updated_at).and_return(Time.now)
    @activity.stub!(:to_s).and_return(@activity.name)

    db_instance_dev = mock_model(DbInstance)
    db_instance_dev.stub!(:db_env).and_return(DbInstance::ENV_DEV)
    @activity.stub!(:db_instances).and_return([db_instance_dev])

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

    changes = mock(Array)
    changes.should_receive(:empty?).and_return(true)
    @activity.stub!(:changes).and_return(changes)
    
    assigns[:change] = @change
    assigns[:activity] = @activity
  end

  it "should render attributes in <p>" do
    render "/activities/show.html.erb"
    response.should have_text(/Activity 1 Development/)
    response.should have_text(/brazil_dev/)
    response.should have_text(/development/)
  end
end

