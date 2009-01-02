require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/apps/edit.html.erb" do
  include AppsHelper
  
  before do
    @app = mock_model(App)
    @app.stub!(:name).and_return("MyString")
    assigns[:app] = @app
  end

  it "should render edit form" do
    render "/apps/edit.html.erb"
    
    response.should have_tag("form[action=#{app_path(@app)}][method=post]") do
      with_tag('input#app_name[name=?]', "app[name]")
    end
  end
end


