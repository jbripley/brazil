require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/db_instances/new.html.erb" do
  include DbInstancesHelper
  
  before(:each) do
    @db_instance = mock_model(DbInstance)
    @db_instance.stub!(:new_record?).and_return(true)
    @db_instance.stub!(:db_alias).and_return("MyString")
    @db_instance.stub!(:db_env).and_return("MyString")
    @db_instance.stub!(:db_type).and_return("MyString")
    @db_instance.stub!(:host).and_return("MyString")
    @db_instance.stub!(:port).and_return("1")
    assigns[:db_instance] = @db_instance 
  end

  it "should render new form" do
    render "/db_instances/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", db_instances_path) do
      with_tag("input#db_instance_db_alias[name=?]", "db_instance[db_alias]")
      with_tag("select#db_instance_db_env[name=?]", "db_instance[db_env]")
      with_tag("select#db_instance_db_type[name=?]", "db_instance[db_type]")
      with_tag("input#db_instance_host[name=?]", "db_instance[host]")
      with_tag("input#db_instance_port[name=?]", "db_instance[port]")
    end
  end
end


