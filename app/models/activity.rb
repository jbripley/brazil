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
  
  def versioned?
    (state == Activity::STATE_VERSIONED)
  end
  
  def deployed?
    (state == Activity::STATE_DEPLOYED)
  end
  
  def development!
    self.state = STATE_DEVELOPMENT
  end
  
  def versioned!
    self.state = STATE_VERSIONED
  end
  
  def deployed!
    self.state = STATE_DEPLOYED
  end
  
  def to_s
    name
  end
end
