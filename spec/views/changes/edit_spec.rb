require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/changes/edit.html.erb" do
  include ChangesHelper
  fixtures :apps, :activities
  
  before do
    @app = apps(:app_1)

    @activity = activities(:app_1_dev)
    @activity.stub!(:app).and_return(@app)  

    assigns[:activity] = @activity

    @change = mock_model(Change)
    @change.stub!(:dba).and_return("MyString")
    @change.stub!(:developer).and_return("MyString")
    @change.stub!(:sql).and_return("MyText")
    @change.stub!(:state).and_return("MyString")
    assigns[:change] = @change
  end

  it "should render edit form" do
    render "/changes/edit.html.erb"
    
    response.should have_tag("form[action=#{app_activity_change_path(@app, @activity, @change)}][method=post]") do
      with_tag('input#change_dba[name=?]', "change[dba]")
      with_tag('input#change_developer[name=?]', "change[developer]")
      with_tag('textarea#change_sql[name=?]', "change[sql]")   
    end
  end
end


