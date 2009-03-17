require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/db_instances/index.html.erb" do
  include DbInstancesHelper

  before(:each) do
    db_instance_98 = mock_model(DbInstance)
    db_instance_98.should_receive(:db_alias).and_return("Dev1")
    db_instance_98.should_receive(:db_env).at_least(:once).and_return("dev")
    db_instance_98.should_receive(:db_type).and_return("MySQL")
    db_instance_98.should_receive(:host).and_return("127.0.0.1")
    db_instance_98.should_receive(:port).and_return(3306)

    db_instance_99 = mock_model(DbInstance)
    db_instance_99.should_receive(:db_alias).and_return("Test1")
    db_instance_99.should_receive(:db_env).at_least(:once).and_return("test")
    db_instance_99.should_receive(:db_type).and_return("SQLite")
    db_instance_99.should_receive(:host).and_return("db/test.sqlite")
    db_instance_99.should_receive(:port)

    db_instance_100= mock_model(DbInstance)
    db_instance_100.should_receive(:db_alias).and_return("Prod1")
    db_instance_100.should_receive(:db_env).at_least(:once).and_return("prod")
    db_instance_100.should_receive(:db_type).and_return("PostgreSQL")
    db_instance_100.should_receive(:host).and_return("127.0.0.2")
    db_instance_100.should_receive(:port).and_return(5432)

    assigns[:db_instances] = [db_instance_98, db_instance_99]
    assigns[:db_instances_prod] = [db_instance_100]
  end

  it "should render list of db_instances" do
    render "/db_instances/index.html.erb"
    response.should have_tag("tr>td", "Dev1", 1)
    response.should have_tag("tr>td", "Test1", 1)
    response.should have_tag("tr>td", "Prod1", 1)

    response.should have_tag("tr>td", "dev", 1)
    response.should have_tag("tr>td", "test", 1)
    response.should have_tag("tr>td", "prod", 1)

    response.should have_tag("tr>td", "MySQL", 1)
    response.should have_tag("tr>td", "SQLite", 1)
    response.should have_tag("tr>td", "PostgreSQL", 1)

    response.should have_tag("tr>td", "127.0.0.1", 1)
    response.should have_tag("tr>td", "db/test.sqlite", 1)
    response.should have_tag("tr>td", "127.0.0.2", 1)

    response.should have_tag("tr>td", '3306', 1)
    response.should have_tag("tr>td", '5432', 1)
  end
end

