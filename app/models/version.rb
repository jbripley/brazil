require 'brazil/schema_revision'

class Version < ActiveRecord::Base
  STATE_CREATED = 'created'
  STATE_TESTED = 'tested'
  STATE_DEPLOYED = 'deployed'
  
  belongs_to :activity
  
  has_many :db_instance_version
  has_many :db_instances, :through => :db_instance_version
  
  validates_presence_of :schema, :schema_version, :update_sql, :rollback_sql
  
  before_save :check_no_duplicate_schema_db, :update_activity_state

  def run_sql(generate_update_sql, generate_rollback_sql, db_username, db_password)
    notice = nil
    
    case "#{state}-#{state_was}"
    when "#{STATE_CREATED}-#{STATE_CREATED}" # update
      begin
        self.schema_version = db_instance_test.find_next_schema_version(db_username, db_password, schema)
        notice = 'Version was successfully updated.'
      rescue Brazil::DBException => exception
        errors.add_to_base("Could not lookup version for schema '#{schema}' (#{exception})")
      end
    when "#{STATE_TESTED}-#{STATE_CREATED}" # tested
      begin
        db_instance_test.execute_sql(generate_update_sql.call, db_username, db_password, schema)
        notice = "Executed Update SQL on #{db_instance_test}"
      rescue Brazil::DBException => exception
        errors.add_to_base("Failed to execute Update SQL (#{exception})")
      end
    when "#{STATE_CREATED}-#{STATE_TESTED}" # rollback
      begin
        db_instance_test.execute_sql(generate_rollback_sql.call, db_username, db_password, schema)
        notice = "Executed Rollback SQL on #{db_instance_test}"
      rescue Brazil::DBException => exception
        errors.add_to_base("Failed to execute Rollback SQL (#{exception})")
      end
    when "#{STATE_DEPLOYED}-#{STATE_TESTED}" # deployed
      notice = "Version '#{@version}' is now set as deployed"
    else
      logger.warn("Version#run_sql default case chosen (#{self})")
    end
    
    return notice
  end
  
  def next_schema_version(db_username, db_password)
    begin
      db_instance_test.find_next_schema_version(db_username, db_password, schema)
    rescue Brazil::NoVersionTableException => exception
      errors.add_to_base("Could not lookup version for schema '#{schema}' (#{exception})")
    end
  end
  
  def db_instance_test
    test_db_instance = DbInstance.find(db_instance_ids, :conditions => {:db_env => DbInstance::ENV_TEST}).first
    if test_db_instance
      test_db_instance
    else
      raise Brazil::NoDBInstanceException, "Please select a Test Database for Version"
    end
  end
  
  def schema_revision
    Brazil::SchemaRevision.new(schema, schema_version)
  end
  
  def created?
    (state == STATE_CREATED)
  end
  
  def tested?
    (state == STATE_TESTED)
  end
  
  def deployed?
    (state == STATE_DEPLOYED)
  end
   
  def states
    ['created', 'tested', 'deployed']
  end
  
  def to_s
    "#{schema}@#{db_instance_test}"
  end
  
  private
  
  def check_no_duplicate_schema_db
    match = DbInstanceVersion.find(:first, :joins => [:version, :db_instance], :conditions => ['versions.schema = ? AND db_instances.id = ? AND versions.activity_id = ?', schema, db_instance_test.id, activity.id])
    if match && match.version_id != id
      errors.add_to_base("Creating a second Version with the same Schema '#{schema}' and Test Database '#{db_instance_test}' is not allowed")
      false
    end
  end
  
  def update_activity_state
    if activity.development?
      activity.versioned!
    elsif activity.versioned?
      activity.deployed!
    end
  end
end
