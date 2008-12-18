class Version < ActiveRecord::Base
  STATE_CREATED = 'created'
  STATE_TESTED = 'tested'
  STATE_DEPLOYED = 'deployed'
  
  belongs_to :activity
  
  has_many :db_instance_version
  has_many :db_instances, :through => :db_instance_version
  
  validates_associated :db_instances
  validates_associated :activity
  
  validates_presence_of :schema
  validates_presence_of :update_sql
  validates_presence_of :rollback_sql
  
  before_save :check_no_duplicate_schema_db
    
  def states
    ['created', 'tested', 'deployed']
  end
  
  def to_s
    "#{schema}@#{db_instance_test} v.#{schema_version}"
  end
  
  def db_instance_test
    db_instances.each do |db_instance|
      return db_instance if db_instance.test?
    end
    
    raise "Please select a Test Database for Version"
  end
  
  private
  
  def check_no_duplicate_schema_db
    match = DbInstanceVersion.find(:first, :joins => [:version, :db_instance], :conditions => ['versions.schema = ? AND db_instances.id = ? AND versions.activity_id = ?', schema, db_instance_test.id, activity.id])
    if match && match.version_id != id
      errors.add_to_base("Creating a second Version with the same Schema '#{schema}' and Test Database '#{db_instance_test}' is not allowed")
      false
    end
  end
end
