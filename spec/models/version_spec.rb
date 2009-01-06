require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Version do
  fixtures :versions, :db_instances

  before(:each) do
    @valid_attributes = versions(:version_1_activity_2).attributes

    db_instance = db_instances(:test_1)
    db_instance.stub!(:find).and_return(db_instance)

    mock_db_instances = mock(Array)
    mock_db_instances.stub!(:find).and_return([db_instance])
    mock_db_instances.stub!(:map).and_return([2])
    mock_db_instances.stub!(:first).and_return(db_instance)
    mock_db_instances.stub!(:each).and_return([])

    DbInstance.stub!(:find).and_return(mock_db_instances)

    DbInstanceVersion.stub!(:find).and_return(nil)
  end

  it "should create a new instance given valid attributes" do
    Version.create!(@valid_attributes)
  end
end
