require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/db_instances/show.html.erb" do
  include DbInstancesHelper
  
  before(:each) do
    @db_instance = mock_model(DbInstance)
    @db_instance.stub!(:db_alias).and_return("Alias")
    @db_instance.stub!(:db_env).and_return("Environment")
    @db_instance.stub!(:db_type).and_return("MySQL")
    @db_instance.stub!(:host).and_return("localhost")
    @db_instance.stub!(:port).and_return(3306)

    assigns[:db_instance] = @db_instance 
  end

  it "should render attributes in <p>" do
    render "/db_instances/show.html.erb"
    response.should have_text(/Alias/)
    response.should have_text(/Environment/)
    response.should have_text(/MySQL/)
    response.should have_text(/localhost/)
    response.should have_text(/3306/)
  end
end

