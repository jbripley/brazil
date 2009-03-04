require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Version do
  fixtures :versions, :db_instances

  before(:each) do
    @valid_attributes = versions(:version_1_activity_2).attributes

    db_instance = db_instances(:test_1)
    db_instance.stub!(:find).with(1).and_return(db_instance)

    mock_db_instances = mock(Array)
    mock_db_instances.stub!(:find).and_return([db_instance])
    mock_db_instances.stub!(:map).and_return([2])
    mock_db_instances.stub!(:first).and_return(db_instance)
    mock_db_instances.stub!(:each).and_return([])

    DbInstance.stub!(:find_all_by_id).and_return(mock_db_instances)

    DbInstanceVersion.stub!(:find).and_return(nil)

    @version = Version.new(@valid_attributes)
  end

  describe "when saving an version" do
    it "should be a valid version instance given valid attributes" do
      @version.should be_valid
    end

    it "should be a duplicate of an existing version" do
      db_instance_version = mock_model(DbInstanceVersion)
      db_instance_version.stub!(:version_id).and_return(-1)

      DbInstanceVersion.stub!(:find).and_return(db_instance_version)

      errors = mock(ActiveRecord::Errors, :null_object => true)
      errors.should_receive(:add_to_base)
      @version.stub!(:errors).and_return(errors)
    end

    describe "and updates activity state" do
      it "should change activity state to versioned" do
        activity = mock_model(Activity)
        activity.should_receive(:development?).and_return(true)
        activity.should_receive(:versioned!)

        @version.stub!(:activity).and_return(activity)
      end
    end

    after(:each) do
      @version.save
    end
  end

  describe "when calling db_instance_test" do
    it "should return a test db_instance belonging to the version" do
      db_instance_test = mock_model(DbInstance)
      DbInstance.stub!(:find_all_by_id).and_return([db_instance_test])

      @version.db_instance_test.should eql(db_instance_test)
    end

    it "should find no test db_instance for the version" do
      DbInstance.stub!(:find_all_by_id).and_return([])
      lambda { @version.db_instance_test.should eql(db_instance_test) }.should raise_error(Brazil::NoDBInstanceException)
    end
  end

  describe "when calling schema_revision" do
    it "should return a Brazil::SchemaRevision if there is a schema_version" do
      @version.schema_revision.should == Brazil::SchemaRevision.from_string(@version.schema_version)
    end

    it "should return nil if there is no schema_version" do
      @version.schema_version = nil
      @version.schema_revision.should be_nil
    end
  end


  describe "when calling created?" do
    it "should be true" do
      @version.stub!(:state).and_return(Version::STATE_CREATED)
      @version.created?.should be_true
    end

    it "should be false" do
      @version.stub!(:state).and_return(Version::STATE_TESTED)
      @version.created?.should be_false
    end
  end

  describe "when calling tested?" do
    it "should be true" do
      @version.stub!(:state).and_return(Version::STATE_TESTED)
      @version.tested?.should be_true
    end

    it "should be false" do
      @version.stub!(:state).and_return(Version::STATE_CREATED)
      @version.tested?.should be_false
    end
  end

  describe "when calling deployed?" do
    it "should be true" do
      @version.stub!(:state).and_return(Version::STATE_DEPLOYED)
      @version.deployed?.should be_true
    end

    it "should be false" do
      @version.stub!(:state).and_return(Version::STATE_TESTED)
      @version.deployed?.should be_false
    end
  end

  it "should return an array of states when calling states" do
    @version.states.should == [Version::STATE_CREATED, Version::STATE_TESTED, Version::STATE_DEPLOYED]
  end

  it "should return a string with schema and test db_instance when calling to_s" do
    db_instance_test_to_s = 'brazil foo'
    db_instance_test = mock_model(DbInstance)
    db_instance_test.should_receive(:to_s).and_return(db_instance_test_to_s)
    @version.stub!(:db_instance_test).and_return(db_instance_test)

    @version.to_s == "#{@version.schema}@#{db_instance_test_to_s}"
  end
end
