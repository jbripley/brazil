require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/apps/show.html.erb" do
  include AppsHelper
  
  before(:each) do
    @app = mock_model(App)
    @app.stub!(:name).and_return("MyString")

    assigns[:app] = @app
  end

  it "should render attributes in <p>" do
    render "/apps/show.html.erb"
    response.should have_text(/MyString/)
  end
end

