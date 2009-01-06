require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/change_suggestions/new.html.erb" do
  include ChangeSuggestionsHelper
  fixtures :apps, :activities

  before(:each) do
    @app = apps(:app_1)

    @activity = activities(:app_1_dev)
    @activity.stub!(:app).and_return(@app)

    assigns[:activity] = @activity

    @change = mock_model(Change)
    @change.stub!(:new_record?).and_return(true)
    @change.stub!(:dba).and_return("MyString")
    @change.stub!(:developer).and_return("MyString")
    @change.stub!(:sql).and_return("MyText")
    @change.stub!(:state).and_return("MyString")
    @change.stub!(:activity).and_return(@activity)
    assigns[:change] = @change 
  end

  it "should render new form" do
    render "/change_suggestions/new.html.erb"

    response.should have_tag("form[action=?][method=post]", app_activity_change_suggestions_path(@app, @activity)) do
      with_tag("input#change_developer[name=?]", "change[developer]")
      with_tag("textarea#change_sql[name=?]", "change[sql]")
    end
  end
end

