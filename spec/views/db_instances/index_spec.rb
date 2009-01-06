require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/db_instances/index.html.erb" do
  include DbInstancesHelper
  
  before(:each) do
    db_instance_98 = mock_model(DbInstance)
    db_instance_98.should_receive(:db_alias).and_return("Test1")
    db_instance_98.should_receive(:db_env).at_least(:once).and_return("Environment1")
    db_instance_98.should_receive(:db_type).and_return("MySQL")
    db_instance_98.should_receive(:host).and_return("127.0.0.1")
    db_instance_98.should_receive(:port).and_return(3306)
    
    db_instance_99 = mock_model(DbInstance)
    db_instance_99.should_receive(:db_alias).and_return("Test2")
    db_instance_99.should_receive(:db_env).at_least(:once).and_return("Environment2")
    db_instance_99.should_receive(:db_type).and_return("SQLite")
    db_instance_99.should_receive(:host).and_return("db/test.sqlite")
    db_instance_99.should_receive(:port)

    assigns[:db_instances] = [db_instance_98, db_instance_99] 
  end

  it "should render list of db_instances" do
    render "/db_instances/index.html.erb"
    response.should have_tag("tr>td", "Test1", 1)
    response.should have_tag("tr>td", "Test2", 1)

    response.should have_tag("tr>td", "Environment1", 1)
    response.should have_tag("tr>td", "Environment2", 1)

    response.should have_tag("tr>td", "MySQL", 1)
    response.should have_tag("tr>td", "SQLite", 1)

    response.should have_tag("tr>td", "127.0.0.1", 1)
    response.should have_tag("tr>td", "db/test.sqlite", 1)

    response.should have_tag("tr>td", '3306', 1)
  end
end

