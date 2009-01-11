require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'dbi'

describe DbInstance do
  before(:each) do
    @valid_attributes = {
      :db_alias => 'Spec Test',
      :db_env => 'dev',
      :db_type => 'MySQL',
      :host => 'localhost',
      :port => 3306
    }
    @db_instance = DbInstance.create!(@valid_attributes)

    @username = 'foobar'
    @password = 'sekrit'
    @schema = 'spec_test'
  end

  def setup_handle(dbi_handle)
    dbi_handle.stub!(:disconnect)
    @db_instance.stub!(:db_connection).with(@username, @password, @schema).and_return(dbi_handle)
  end

  it "should be a valid db_instance created from valid attributes" do
    @db_instance.should be_valid
  end

  describe "when calling dev?" do
    it "should be true" do
      @db_instance.db_env = DbInstance::ENV_DEV
      @db_instance.dev?.should be_true
    end

    it "should be false" do
      @db_instance.db_env = DbInstance::ENV_TEST
      @db_instance.dev?.should be_false
    end
  end

  describe "when calling test?" do
    it "should be true" do
      @db_instance.db_env = DbInstance::ENV_TEST
      @db_instance.test?.should be_true
    end

    it "should be false" do
      @db_instance.db_env = DbInstance::ENV_DEV
      @db_instance.test?.should be_false
    end
  end

  describe "when calling execute_sql" do
    before(:each) do
      @dbi_handle = mock(DBI::DatabaseHandle)
      @dbi_handle.stub!(:transaction).and_yield(@dbi_handle)
    end

    it "should execute correct SQL statement" do
      sql = 'create table foo(bar int, baz varchar(20)'

      @dbi_handle.stub!(:do).with(sql)
      setup_handle(@dbi_handle)

      @db_instance.execute_sql(sql, @username, @password, @schema)
    end

    it "should execute a faulty SQL statement" do
      sql = 'creat tabl foo(bar int, baz varchar(20'

      @dbi_handle.stub!(:do).with(sql).and_raise(DBI::DatabaseError)
      setup_handle(@dbi_handle)

      lambda { @db_instance.execute_sql(sql, @username, @password, @schema) }.should raise_error(Brazil::DBExecuteSQLException)
    end
  end

  describe "when calling find_next_schema_version" do
    before(:each) do
      @dbi_handle = mock(DBI::DatabaseHandle)
    end

    it "should find a schema version" do
      tables = mock(Array)
      tables.stub!(:each).and_yield('foo_table').and_yield('baz_table').and_yield('_VERSION_FOO_3_14')
      @dbi_handle.stub!(:tables).and_return(tables)
      setup_handle(@dbi_handle)

      @db_instance.find_next_schema_version(@username, @password, @schema).should eql('3_15')
    end

    it "should find no schema version" do
      tables = mock(Array)
      tables.stub!(:each).and_yield('foo_table').and_yield('baz_table')
      @dbi_handle.stub!(:tables).and_return(tables)
      setup_handle(@dbi_handle)

      lambda { @db_instance.find_next_schema_version(@username, @password, @schema) }.should raise_error(Brazil::NoVersionTableException)
    end

    it "should raise a DB exception" do
      @dbi_handle.stub!(:tables).and_raise(DBI::DatabaseError)
      setup_handle(@dbi_handle)

      lambda { @db_instance.find_next_schema_version(@username, @password, @schema) }.should raise_error(Brazil::DBException)
    end
  end

  describe "when calling check_db_credentials" do
    it "should approve them" do
      setup_handle(mock(DBI::DatabaseHandle))
      @db_instance.check_db_credentials(@username, @password, @schema).should be_true
    end

    it "should reject them" do
      @db_instance.stub!(:db_connection).with(@username, @password, @schema).and_raise(DBI::DatabaseError)
      @db_instance.check_db_credentials(@username, @password, @schema).should be_false
    end
  end

  describe "when calling db_connection" do
    it "should fail to load DBI module" do
      @db_instance.stub!(:require).with('dbi').and_raise(LoadError)
      lambda { @db_instance.send :db_connection, @username, @password, @schema }.should raise_error(Brazil::LoadException)
    end

    it "should create a MySQL connection" do
      dbi_handle = mock(DBI::DatabaseHandle)
      dbi_handle.should_receive(:do).with('SET NAMES utf8')

      DBI.should_receive(:connect).with("DBI:Mysql:database=#{@schema};host=#{@db_instance.host};port=#{@db_instance.port}", @username, @password).and_return(dbi_handle)

      @db_instance.send :db_connection, @username, @password, @schema
    end

    it "should create a Oracle connection" do
      dbi_handle = mock(DBI::DatabaseHandle)

      @db_instance.db_type = DbInstance::TYPE_ORACLE
      @db_instance.host = 'db.example.com/test_sid'
      oracle_host, oracle_instance = @db_instance.host.split('/')
      DBI.should_receive(:connect).with("DBI:OCI8://#{oracle_host}:#{@db_instance.port}/#{oracle_instance}", @username, @password).and_return(dbi_handle)

      @db_instance.send :db_connection, @username, @password, @schema
    end

    it "should fail to create a unknown connection" do
      dbi_handle = mock(DBI::DatabaseHandle)

      @db_instance.db_type = 'Unknown'
      lambda { @db_instance.send :db_connection, @username, @password, @schema }.should raise_error(Brazil::UnknownDBTypeException)
    end

    it "should fail to create a DB connection of a known type" do
      DBI.should_receive(:connect).with("DBI:Mysql:database=#{@schema};host=#{@db_instance.host};port=#{@db_instance.port}", @username, @password).and_return(nil)

      lambda { @db_instance.send :db_connection, @username, @password, @schema }.should raise_error(Brazil::DBConnectionException)
    end
  end
end
