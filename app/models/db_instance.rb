require 'brazil/schema_revision'

class DbInstance < ActiveRecord::Base
  ENV_DEV = 'dev'
  ENV_TEST = 'test'
  ENV_PROD = 'prod'
  
  TYPE_MYSQL = 'MySQL'
  
  def self.db_environments
    [DbInstance::ENV_DEV, DbInstance::ENV_TEST, DbInstance::ENV_PROD]
  end
  
  def self.db_types
    [DbInstance::TYPE_MYSQL]
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
    mysql_connection = nil
    begin
      mysql_connection = mysql_connection(username, password, schema)
      mysql_connection.real_query('BEGIN')
      sql.strip.split(/;[\n\r]/s).each do |sql_part|
        mysql_connection.real_query(sql_part.strip)
      end
      mysql_connection.real_query('COMMIT')
    rescue => exception
      mysql_connection.real_query('ROLLBACK') if mysql_connection
      raise exception
    ensure
      mysql_connection.close if mysql_connection
    end
  end
  
  def find_next_schema_version(username, password, schema)
    schema_version = nil
    mysql_connection = nil
    begin
      mysql_connection = mysql_connection(username, password, schema)
      mysql_connection.list_tables.each do |table_name|
        schema_revision = Brazil::SchemaRevision.from_string(table_name)
        if schema_revision
          return schema_revision.version.next
        end
      end
    ensure
      mysql_connection.close if mysql_connection
    end
    
    raise Brazil::NoVersionTableException, "'#{schema}' has no version table, please create one"
  end
  
  def check_db_credentials(username, password, schema)
    mysql_connection = nil
    begin
      mysql_connection = mysql_connection(username, password, schema)
    ensure
      mysql_connection.close if mysql_connection
    end
    return !mysql_connection.nil?
  end
  
  private
  
  def mysql_connection(username, password, schema)
    begin
      require 'mysql'
    rescue LoadError
      raise 'Failed to load mysql ruby extension, please install'
    end
    
    mysql_connection = Mysql::new(host, username, password, schema, port)
    mysql_connection.real_query('SET NAMES utf8')
    if mysql_connection.nil?
      raise "Failed to connect to MySQL DB (#{username}@#{host}:#{port}/#{schema})"
    else
      return mysql_connection
    end
  end
end
