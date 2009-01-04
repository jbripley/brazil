require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Change do
  before(:each) do
    @valid_attributes = {
      :dba => "dba1@example.com",
      :developer => "developer1@example.com",
      :sql => "create table foo(bar int);",
      :state => "executed",
      :activity_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Change.create!(@valid_attributes)
  end
end
