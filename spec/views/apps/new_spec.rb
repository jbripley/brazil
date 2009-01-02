require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/apps/new.html.erb" do
  include AppsHelper
  
  before(:each) do
    @app = mock_model(App)
    @app.stub!(:new_record?).and_return(true)
    @app.stub!(:name).and_return("MyString")
    assigns[:app] = @app
  end

  it "should render new form" do
    render "/apps/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", apps_path) do
      with_tag("input#app_name[name=?]", "app[name]")
    end
  end
end


