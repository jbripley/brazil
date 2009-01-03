require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/activities/edit.html.erb" do
  include ActivitiesHelper
  fixtures :apps, :db_instances
  
  before do
    @app = apps(:app_1)
    assigns[:app] = @app
    
    @activity = mock_model(Activity)
    @activity.stub!(:name).and_return("MyString")
    @activity.stub!(:description).and_return("MyString")
    @activity.stub!(:schema).and_return("MyString")
    @activity.stub!(:state).and_return("MyString")
    @activity.stub!(:app_id).and_return("1")
    
    @activity.stub!(:db_instance_ids).and_return(db_instances)
    
    assigns[:activity] = @activity
  end

  it "should render edit form" do
    render "/activities/edit.html.erb"
    
    response.should have_tag("form[action=#{app_activity_path(@app, @activity)}][method=post]") do
      with_tag('input#activity_name[name=?]', "activity[name]")
      with_tag('textarea#activity_description[name=?]', "activity[description]")
      with_tag('input#activity_schema[name=?]', "activity[schema]")
    end
  end
end


