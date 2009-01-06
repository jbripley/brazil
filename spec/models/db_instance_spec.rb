require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DbInstance do
  before(:each) do
    @valid_attributes = {
      :db_alias => 'Spec Test',
      :db_env => 'dev',
      :db_type => 'MySQL',
      :host => 'localhost',
      :port => 3306
    }
  end

  it "should create a new instance given valid attributes" do
    DbInstance.create!(@valid_attributes)
  end
end
