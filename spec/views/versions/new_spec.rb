require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/versions/new.html.erb" do
  include VersionsHelper
  fixtures :apps, :activities, :db_instances

  before do
    @app = apps(:app_1)

    @activity = activities(:app_1_dev)
    @activity.stub!(:app).and_return(@app)

    assigns[:activity] = @activity

    @version = mock_model(Version)
    @version.stub!(:new_record?).and_return(true)
    @version.stub!(:state).and_return("MyString")
    @version.stub!(:schema).and_return("MyString")
    @version.stub!(:schema_version).and_return("MyString")
    @version.stub!(:preparation).and_return("MyString")
    @version.stub!(:deploy_note).and_return("MyString")
    @version.stub!(:update_sql).and_return("MyText")
    @version.stub!(:rollback_sql).and_return("MyText")

    @version.stub!(:db_instance_ids).and_return([1])

    assigns[:version] = @version 
  end

  it "should render new form" do
    render "/versions/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", app_activity_versions_path(@app, @activity)) do
      with_tag("input#version_state[name=?]", "version[state]")
      with_tag("input#version_schema[name=?]", "version[schema]")   
      with_tag("textarea#version_preparation[name=?]", "version[preparation]")   
      with_tag("textarea#version_update_sql[name=?]", "version[update_sql]")
      with_tag("textarea#version_rollback_sql[name=?]", "version[rollback_sql]")
    end
  end
end


