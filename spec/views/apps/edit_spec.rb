require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/apps/edit.html.erb" do
  include AppsHelper

  before do
    @app = mock_model(App)
    @app.stub!(:name).and_return("App")
    @app.stub!(:vc_path).and_return("/apps_name/trunk/db")
    assigns[:app] = @app
  end

  it "should render edit form" do
    render "/apps/edit.html.erb"

    response.should have_tag("form[action=#{app_path(@app)}][method=post]") do
      with_tag('input#app_name[name=?]', "app[name]")
      with_tag('input#app_vc_path[name=?]', "app[vc_path]")
    end
  end
end


