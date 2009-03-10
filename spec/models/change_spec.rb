require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Change do
  before(:each) do
    @valid_attributes = {
        :id => 125,
        :sql => "CREATE TABLE new_weird_table (\nweird_id INT(10) unsigned NOT NULL,\nstupid_name VARCHAR(24) NOT NULL default ''\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;",
        :state => Change::STATE_EXECUTED,
        :dba => "dba1@example.com",
        :developer => "developer1@example.com",
        :activity_id => 124
    }

    db_instance = mock_model(DbInstance)
    db_instance.stub!(:find).with(1).and_return(db_instance)

    mock_db_instances = mock(Array)
    mock_db_instances.stub!(:find).and_return([db_instance])
    mock_db_instances.stub!(:map).and_return([2])
    mock_db_instances.stub!(:first).and_return(db_instance)
    mock_db_instances.stub!(:each).and_return([])

    DbInstance.stub!(:find_all_by_id).and_return(mock_db_instances)

    @activity = mock_model(Activity)
    @activity.stub!(:development?).and_return(true)

    @change = Change.new(@valid_attributes)
    @change.stub!(:activity).and_return(@activity)
  end

  describe "when saving an change" do
    it "should be a valid version instance given valid attributes" do
      time_now = Time.now
      Time.stub!(:now).and_return(time_now)
      @activity.should_receive(:update_attribute).with(:updated_at, time_now)

      @change.should be_valid
      @change.save.should be_true
    end

    it "should belong to an activity in the wrong state" do
      @activity.stub!(:development?).and_return(false)

      errors = mock(ActiveRecord::Errors, :null_object => true)
      errors.should_receive(:add_to_base)
      @change.stub!(:errors).and_return(errors)
      @change.save.should be_false
    end

    it "should not be a valid email when not a suggested change" do
      time_now = Time.now
      Time.stub!(:now).and_return(time_now)
      @activity.should_receive(:update_attribute).with(:updated_at, time_now)

      @change.stub!(:dba).and_return('_dcew32432ew-_)+_(_)**!')

      errors = mock(ActiveRecord::Errors, :null_object => true)
      errors.should_receive(:add)
      @change.stub!(:errors).and_return(errors)
      @change.save.should be_true
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
