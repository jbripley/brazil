require 'brazil/schema_revision'

class DbInstance < ActiveRecord::Base
  ENV_DEV = 'dev'
  ENV_TEST = 'test'
  ENV_PROD = 'prod'

  TYPE_MYSQL = 'MySQL'
  TYPE_ODBC = 'ODBC'
  TYPE_ORACLE = 'Oracle8'
  TYPE_POSTGRES = 'PostgreSQL'

  validates_presence_of :db_alias, :host, :port, :db_env, :db_type

  named_scope :env_test, :conditions => {:db_env => ENV_TEST}
  named_scope :env_dev, :conditions => {:db_env => ENV_DEV}

  def self.db_environments
    [ENV_DEV, ENV_TEST, ENV_PROD]
  end

  def self.db_types
    # TODO: Only MySQL, Oracle and PostgreSQL support implemented for now
    [TYPE_MYSQL, TYPE_ORACLE, TYPE_POSTGRES] #, TYPE_ODBC ]
  end

  def dev?
    (db_env == DbInstance::ENV_DEV)
  end

  def test?
    (db_env == DbInstance::ENV_TEST)
  end

  def to_s
    db_alias
  end

  def execute_sql(sql, username, password, schema)
    db_connection = nil
    begin
      db_connection = db_connection(username, password, schema)
      db_connection['AutoCommit'] = false
      db_connection.transaction do |dbh|
        sql_no_comments = sql.gsub(/\-\-\s.*?[\n\r]/, '')
        sql_no_comments.strip.split(/;(?:[\n\r])?/s).each do |sql_part|
          dbh.do(sql_part.strip)
        end
      end
    rescue DBI::DatabaseError => exception
      raise Brazil::DBExecuteSQLException, exception.errstr
    ensure
      if db_connection
        db_connection['AutoCommit'] = true
        db_connection.disconnect
      end
    end
  end

  def find_next_schema_version(username, password, schema)
    schema_version = nil
    db_connection = nil

    unless check_db_credentials(username, password, schema)
      raise Brazil::DBConnectionException, "Wrong database username or password entered"
    end

    begin
      db_connection = db_connection(username, password, schema)
      latest_version_row = db_connection.select_one("SELECT * FROM #{schema}.schema_versions ORDER BY major, minor, patch DESC")
      if latest_version_row
        schema_version = Brazil::SchemaRevision.new(latest_version_row['MAJOR'], latest_version_row['MINOR'], latest_version_row['PATCH']).next.to_s
      end
    rescue DBI::DatabaseError => exception
      # No schema_versions table found, return no schema version
    ensure
      db_connection.disconnect if db_connection
    end

    return schema_version
  end

  def check_db_credentials(username, password, schema)
    db_connection = nil
    begin
      db_connection = db_connection(username, password, schema)
    rescue DBI::DatabaseError => exception
      logger.warn("DB Credentials were not correct, #{username}@#{schema}")
      return false
    ensure
      db_connection.disconnect if db_connection
    end

    return true
  end

  private

  def db_connection(username, password, schema)
    begin
      require 'dbi'
    rescue LoadError
      raise Brazil::LoadException, 'Failed to load the DBI module, please install.'
    end

    connection = nil
    case db_type
    when TYPE_MYSQL
      connection = DBI.connect("DBI:Mysql:database=#{schema};host=#{host};port=#{port}", username, password)
      connection.do('SET NAMES utf8') if connection
    # when TYPE_ODBC
    when TYPE_ORACLE
      oracle_host, oracle_instance = host.split('/')
      connection = DBI.connect("DBI:OCI8://#{oracle_host}:#{port}/#{oracle_instance}", username, password)
    when TYPE_POSTGRES
      connection = DBI.connect("DBI:Pg:database=#{schema};host=#{host};port=#{port}", username, password)
    else
      raise Brazil::UnknownDBTypeException, "Trying to create connection for unsupported DB Type: #{db_type}"
    end

    if connection.nil?
      raise Brazil::DBConnectionException, "Failed to connect to DB (#{username}@#{host}:#{port}/#{schema})"
    else
      return connection
    end
  end
end
