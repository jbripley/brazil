class Activity < ActiveRecord::Base
  STATE_DEVELOPMENT = 'development'
  STATE_VERSIONED = 'versioned'
  STATE_DEPLOYED = 'deployed'
  
  belongs_to :app
  has_many :version
  has_many :changes, :order => "created_at DESC"
  
  has_many :db_instance_activity
  has_many :db_instances, :through => :db_instance_activity
  
  validates_associated :db_instances
  validates_presence_of :name
  
  def development?
    (state == Activity::STATE_DEVELOPMENT)
  end
  
 def db_instance_dev
    db_instances.each do |db_instance|
      return db_instance if db_instance.dev?
    end
  end
  
  def to_s
    name
  end
end
