require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Change do
  fixtures :changes, :db_instances

  before(:each) do
    @valid_attributes = changes(:change_1_activity_1).attributes

    db_instance = db_instances(:test_1)
    db_instance.stub!(:find).with(1).and_return(db_instance)

    mock_db_instances = mock(Array)
    mock_db_instances.stub!(:find).and_return([db_instance])
    mock_db_instances.stub!(:map).and_return([2])
    mock_db_instances.stub!(:first).and_return(db_instance)
    mock_db_instances.stub!(:each).and_return([])

    DbInstance.stub!(:find_all_by_id).and_return(mock_db_instances)

    @change = Change.new(@valid_attributes)
  end

  describe "when saving an change" do
    before(:each) do

    end

    it "should be a valid version instance given valid attributes" do
      @change.should be_valid
    end

    it "should belong to an activity in the wrong state" do
      activity = mock_model(Activity)
      activity.should_receive(:valid?).and_return(true)
      activity.should_receive(:development?).and_return(false)
      @change.stub!(:activity).and_return(activity)

      errors = mock(ActiveRecord::Errors, :null_object => true)
      errors.should_receive(:add_to_base)
      @change.stub!(:errors).and_return(errors)
    end

    it "should mark the activity it belongs to as updated" do
      activity = mock_model(Activity)
      activity.should_receive(:valid?).and_return(true)
      activity.should_receive(:development?).and_return(true)

      time_now = Time.now
      Time.stub!(:now).and_return(time_now)

      activity.should_receive(:update_attribute).with(:updated_at, time_now)
      @change.stub!(:activity).and_return(activity)
    end

    it "should check an invalid email" do
      @change.valid_email?('_dcew32432ew-_)+_(_)**!').should be_false
    end

    it "should not be a valid email when not a suggested change" do
      @change.stub!(:dba).and_return('_dcew32432ew-_)+_(_)**!')

      errors = mock(ActiveRecord::Errors, :null_object => true)
      errors.should_receive(:add)
      @change.stub!(:errors).and_return(errors)
    end

    after(:each) do
      @change.save
    end
  end

  describe "when calling use_sql" do
    before(:each) do
      @db_username = 'foo'
      @db_password = 'bar'
    end

    describe "and tries to execute the SQL" do
      before(:each) do
        @activity_schema = 'foo_bar'
        activity = mock_model(Activity)
        activity.should_receive(:schema).and_return(@activity_schema)
        @change.stub!(:activity).and_return(activity)

        @sql = 'CREATE TABLE foo(bar varchar(42))'
        @change.stub!(:state).and_return(Change::STATE_EXECUTED)
      end

      it "should successfully execute the SQL" do
        db_instance_dev = mock_model(DbInstance)
        db_instance_dev.should_receive(:execute_sql).with(@sql, @db_username, @db_password, @activity_schema)

        @change.stub!(:db_instance_dev).and_return(db_instance_dev)

        @change.use_sql(@sql, @db_username, @db_password).should be_true
      end

      it "should raise a DB exception when executing the SQL" do
        db_instance_dev = mock_model(DbInstance)
        db_instance_dev.should_receive(:execute_sql).with(@sql, @db_username, @db_password, @activity_schema).and_raise(Brazil::DBException)

        @change.stub!(:db_instance_dev).and_return(db_instance_dev)

        errors = mock(ActiveRecord::Errors, :null_object => true)
        errors.should_receive(:add)
        @change.stub!(:errors).and_return(errors)

        @change.use_sql(@sql, @db_username, @db_password).should be_false
      end
    end

    describe "and tries to only save the SQL" do
      before(:each) do
        @activity_schema = 'foo_bar'
        activity = mock_model(Activity)
        activity.should_receive(:schema).and_return(@activity_schema)
        @change.stub!(:activity).and_return(activity)

        @change.stub!(:state).and_return(Change::STATE_SAVED)
      end

      it "should successfully save the SQL" do
        db_instance_dev = mock_model(DbInstance)
        db_instance_dev.should_receive(:check_db_credentials).with(@db_username, @db_password, @activity_schema).and_return(true)

        @change.stub!(:db_instance_dev).and_return(db_instance_dev)

        @change.use_sql(@sql, @db_username, @db_password).should be_true
      end

      it "should have the wrong DB credentials" do
        db_instance_dev = mock_model(DbInstance)
        db_instance_dev.should_receive(:check_db_credentials).with(@db_username, @db_password, @activity_schema).and_return(false)

        @change.stub!(:db_instance_dev).and_return(db_instance_dev)

        errors = mock(ActiveRecord::Errors, :null_object => true)
        errors.should_receive(:add_to_base)
        @change.stub!(:errors).and_return(errors)

        @change.use_sql(@sql, @db_username, @db_password).should be_false
      end
    end

    it "should be in an unknown change state" do
      @change.stub!(:state).and_return('UNKNOWN')

      lambda { @change.use_sql(@sql, @db_username, @db_password) }.should raise_error(Brazil::UnknowStateException)
    end

  end

  describe "when calling db_instance_dev" do
    it "should return a dev db instance" do
      db_instance_dev = mock_model(DbInstance)
      db_instance_dev.should_receive(:dev?).and_return(true)

      activity = mock_model(Activity)
      activity.should_receive(:db_instances).and_return([db_instance_dev])
      @change.stub!(:activity).and_return(activity)

      @change.send(:db_instance_dev).should eql(db_instance_dev)
    end

    it "should not find any db dev instances" do
      activity = mock_model(Activity)
      activity.should_receive(:db_instances).and_return([])
      @change.stub!(:activity).and_return(activity)

      lambda { @change.send(:db_instance_dev) }.should raise_error(Brazil::NoDBInstanceException)   
    end

    after(:each) do

    end
  end
  
end
