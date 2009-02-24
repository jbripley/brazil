require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/apps/new.html.erb" do
  include AppsHelper

  before(:each) do
    @app = mock_model(App)
    @app.stub!(:new_record?).and_return(true)
    @app.stub!(:name).and_return("App")
    @app.stub!(:vc_path).and_return("/app_name/trunk/db")
    assigns[:app] = @app
  end

  it "should render new form" do
    render "/apps/new.html.erb"

    response.should have_tag("form[action=?][method=post]", apps_path) do
      with_tag("input#app_name[name=?]", "app[name]")
      with_tag("input#app_vc_path[name=?]", "app[vc_path]")
    end
  end
end


