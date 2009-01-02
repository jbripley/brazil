require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Activity do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :schema => "value for schema",
      :state => "value for state",
      :app_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Activity.create!(@valid_attributes)
  end
end
