require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/apps/show.html.erb" do
  include AppsHelper

  before(:each) do
    @app = mock_model(App)
    @app.stub!(:name).and_return("App")
    @app.stub!(:vc_path).and_return("/app_name/trunk/db")

    assigns[:app] = @app
  end

  it "should render attributes in <p>" do
    render "/apps/show.html.erb"
    response.should have_text(/App/)
    response.should have_text(/app_name/)
  end
end

