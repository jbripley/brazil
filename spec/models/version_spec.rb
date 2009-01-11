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

      it "should change activity state to deployed" do
        activity = mock_model(Activity)
        activity.should_receive(:development?).and_return(false)
        activity.should_receive(:versioned?).and_return(true)
        activity.should_receive(:deployed!)

        @version.stub!(:activity).and_return(activity)
      end
    end

    after(:each) do
      @version.save
    end
  end

  describe "when calling run_sql" do
    before(:each) do
      @db_username = 'foo'
      @db_password = 'bar'
    end

    describe "and tries to update schema_version" do
      before(:each) do
        @version.stub!(:state).and_return(Version::STATE_CREATED)
        @version.stub!(:state_was).and_return(Version::STATE_CREATED)
      end

      it "should find the next schema version" do
        schema_version = '3_14'
        db_instance_test = mock_model(DbInstance)
        db_instance_test.should_receive(:find_next_schema_version).with(@db_username, @db_password, @version.schema).and_return(schema_version)

        @version.stub!(:db_instance_test).and_return(db_instance_test)

        @version.run_sql(nil, nil, @db_username, @db_password)
        @version.schema_version.should eql(schema_version)
      end

      it "should not find a schema version" do
        db_instance_test = mock_model(DbInstance)
        db_instance_test.should_receive(:find_next_schema_version).with(@db_username, @db_password, @version.schema).and_raise(Brazil::DBException)

        @version.stub!(:db_instance_test).and_return(db_instance_test)

        errors = mock(ActiveRecord::Errors, :null_object => true)
        errors.should_receive(:add_to_base)
        @version.stub!(:errors).and_return(errors)

        @version.run_sql(nil, nil, @db_username, @db_password)
      end
    end

    describe "and tries to execute update SQL" do
      before(:each) do
        @version.stub!(:state).and_return(Version::STATE_TESTED)
        @version.stub!(:state_was).and_return(Version::STATE_CREATED)
      end

      it "should execute the update SQL" do
        update_sql = 'create table foo(bar int, baz varchar(20));'
        generate_update_sql = mock(Proc)
        generate_update_sql.stub!(:call).and_return(update_sql)

        db_instance_test = mock_model(DbInstance)
        db_instance_test.should_receive(:execute_sql).with(update_sql, @db_username, @db_password, @version.schema)

        @version.stub!(:db_instance_test).and_return(db_instance_test)

        @version.run_sql(generate_update_sql, nil, @db_username, @db_password).should_not be_nil
      end

      it "should get a DB exception" do
        update_sql = 'creat tabl foo(bar in, baz varchar(20);'
        generate_update_sql = mock(Proc)
        generate_update_sql.stub!(:call).and_return(update_sql)

        db_instance_test = mock_model(DbInstance)
        db_instance_test.should_receive(:execute_sql).with(update_sql, @db_username, @db_password, @version.schema).and_raise(Brazil::DBException)

        @version.stub!(:db_instance_test).and_return(db_instance_test)

        errors = mock(ActiveRecord::Errors, :null_object => true)
        errors.should_receive(:add_to_base)
        @version.stub!(:errors).and_return(errors)

        @version.run_sql(generate_update_sql, nil, @db_username, @db_password).should be_nil
      end
    end

    describe "and tries to execute rollback SQL" do
      before(:each) do
        @version.stub!(:state).and_return(Version::STATE_CREATED)
        @version.stub!(:state_was).and_return(Version::STATE_TESTED)
      end
      
      it "should execute the rollback SQL" do
        rollback_sql = 'drop table foo;'
        generate_rollback_sql = mock(Proc)
        generate_rollback_sql.stub!(:call).and_return(rollback_sql)

        db_instance_test = mock_model(DbInstance)
        db_instance_test.should_receive(:execute_sql).with(rollback_sql, @db_username, @db_password, @version.schema)

        @version.stub!(:db_instance_test).and_return(db_instance_test)

        @version.run_sql(nil, generate_rollback_sql, @db_username, @db_password).should_not be_nil
      end

      it "should get a DB exception" do
        rollback_sql = 'drop table foo;'
        generate_rollback_sql = mock(Proc)
        generate_rollback_sql.stub!(:call).and_return(rollback_sql)

        db_instance_test = mock_model(DbInstance)
        db_instance_test.should_receive(:execute_sql).with(rollback_sql, @db_username, @db_password, @version.schema).and_raise(Brazil::DBException)

        @version.stub!(:db_instance_test).and_return(db_instance_test)

        errors = mock(ActiveRecord::Errors, :null_object => true)
        errors.should_receive(:add_to_base)
        @version.stub!(:errors).and_return(errors)

        @version.run_sql(nil, generate_rollback_sql, @db_username, @db_password).should be_nil
      end
    end

    it "should note that version is deployed" do
      @version.stub!(:state).and_return(Version::STATE_DEPLOYED)
      @version.stub!(:state_was).and_return(Version::STATE_TESTED)

      @version.run_sql(nil, nil, @db_username, @db_password).should_not be_nil
    end

    it "should run the default case" do
      @version.stub!(:state).and_return('Unknown')
      @version.stub!(:state_was).and_return('Unknown')

      logger = mock(Logger, :null_object => true)
      logger.should_receive(:warn)
      @version.stub!(:logger).and_return(logger)

      @version.run_sql(nil, nil, @db_username, @db_password).should be_nil
    end
  end

  describe "when calling next_schema_version" do
    before(:each) do
      @db_username = 'foo'
      @db_password = 'bar'
    end

    it "should return the next schema version" do
      schema_version = '3_14'
      db_instance_test = mock_model(DbInstance)
      db_instance_test.should_receive(:find_next_schema_version).with(@db_username, @db_password, @version.schema).and_return(schema_version)
      @version.stub!(:db_instance_test).and_return(db_instance_test)

      @version.next_schema_version(@db_username, @db_password).should eql(schema_version)
    end

    it "should handle an DB exception" do
      schema_version = '3_14'
      db_instance_test = mock_model(DbInstance)
      db_instance_test.should_receive(:find_next_schema_version).with(@db_username, @db_password, @version.schema).and_raise(Brazil::NoVersionTableException)

      @version.stub!(:db_instance_test).and_return(db_instance_test)

      errors = mock(ActiveRecord::Errors, :null_object => true)
      errors.should_receive(:add_to_base)
      @version.stub!(:errors).and_return(errors)

      @version.next_schema_version(@db_username, @db_password)
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

  it "should return a Brazil::SchemaRevision when calling schema_revision" do
    @version.schema_revision.should == Brazil::SchemaRevision.new(@version.schema, @version.schema_version)
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
