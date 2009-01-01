require 'brazil/schema_revision'

class DbInstance < ActiveRecord::Base
  ENV_DEV = 'dev'
  ENV_TEST = 'test'
  
  TYPE_MYSQL = 'MySQL'
  TYPE_ODBC = 'ODBC'
  TYPE_ORACLE = 'Oracle8'
  TYPE_POSTGRES = 'PostgreSQL'
  TYPE_SQLITE = 'SQLite'
  TYPE_SQLITE3 = 'SQLite3'

  validates_presence_of :db_alias, :host, :port, :db_env, :db_type

  named_scope :env_test, :conditions => {:db_env => ENV_TEST}
  named_scope :env_dev, :conditions => {:db_env => ENV_DEV}
  
  def self.db_environments
    [ENV_DEV, ENV_TEST]
  end
  
  def self.db_types
    [TYPE_MYSQL] # TODO: Only MySQL supported implemented for now
    # [TYPE_MYSQL, TYPE_ODBC, TYPE_ORACLE, TYPE_POSTGRES, TYPE_SQLITE, TYPE_SQLITE3]
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
        sql.strip.split(/;[\n\r]/s).each do |sql_part|
          dbh.do(sql_part.strip)
        end
      end
      db_connection['AutoCommit'] = true
    rescue DBI::DatabaseError => exception
      raise Brazil::DBExecuteSQLException, exception.errstr
    ensure
      db_connection.disconnect if db_connection
    end
  end
  
  def find_next_schema_version(username, password, schema)
    schema_version = nil
    db_connection = nil
    begin
      db_connection = db_connection(username, password, schema)
      db_connection.tables.each do |table_name|
        schema_revision = Brazil::SchemaRevision.from_string(table_name)
        if schema_revision
          return schema_revision.version.next
        end
      end
    rescue DBI::DatabaseError => exception
      raise Brazil::DBException, exception.errstr
    ensure
      db_connection.disconnect if db_connection
    end
    
    raise Brazil::NoVersionTableException, "'#{schema}' has no version table, please create one"
  end
  
  def check_db_credentials(username, password, schema)
    db_connection = nil
    begin
      db_connection = db_connection(username, password, schema)
      return true
    rescue DBI::DatabaseError => exception
      logger.warn("DB Credentials were not correct, #{username}@#{schema}")
      return false
    ensure
      db_connection.disconnect if db_connection
    end
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
      connection = DBI.connect("DBI:Mysql:#{schema}:#{host}:#{port}", username, password)
      connection.do('SET NAMES utf8')
    # when TYPE_ODBC
    # when TYPE_ORACLE
    # when TYPE_POSTGRES
    # when TYPE_SQLITE
    # when TYPE_SQLITE3
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
