require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/apps/index.html.erb" do
  include AppsHelper
  fixtures :activities
  
  before(:each) do
    activities_chain = stub(Array)
    activities_chain.stub!('latest').and_return([activities(:app_1_dev)])
    activities_chain.stub!('size').and_return(1)
    
    app_98 = mock_model(App)
    app_98.should_receive(:id).any_number_of_times.and_return(98)
    app_98.should_receive(:to_s).and_return("MyString")
    app_98.should_receive(:activities).exactly(2).and_return(activities_chain)
    
    app_99 = mock_model(App)
    app_98.should_receive(:id).any_number_of_times.and_return(99)
    app_99.should_receive(:to_s).and_return("MyString")
    app_99.should_receive(:activities).exactly(2).and_return(activities_chain)
    
    new_app = mock_model(App)
    new_app.should_receive(:name).and_return('')

    assigns[:apps] = [app_98, app_99]
    assigns[:app] = new_app
  end

  it "should render list of apps" do
    render "/apps/index.html.erb"
    response.should have_tag("h3", "MyString", 2)
  end
end

