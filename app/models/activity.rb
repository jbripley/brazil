class Activity < ActiveRecord::Base
  STATE_DEVELOPMENT = 'development'
  STATE_VERSIONED = 'versioned'
  STATE_DEPLOYED = 'deployed'
  
  belongs_to :app
  has_many :versions
  has_many :changes, :order => "created_at DESC"
  
  has_many :db_instance_activity
  has_many :db_instances, :through => :db_instance_activity
  
  validates_associated :db_instances
  validates_presence_of :name

  named_scope :latest, lambda { |limit| {:order => 'updated_at DESC', :limit => limit} }
  
  def development?
    (state == Activity::STATE_DEVELOPMENT)
  end
  
  def versioned?
    (state == Activity::STATE_VERSIONED)
  end
   
  def versioned!
    update_attribute(:state, STATE_VERSIONED)
  end

  def deployed!
    update_attribute(:state, STATE_DEPLOYED)
  end
    
  def to_s
    name
  end
end
