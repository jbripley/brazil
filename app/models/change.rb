class Change < ActiveRecord::Base
  STATE_SUGGESTED = 'suggested'
  STATE_SAVED = 'saved'
  STATE_EXECUTED = 'executed'
  
  belongs_to :activity
  
  validates_associated :activity
  validates_presence_of :sql
  
  before_save :check_correct_state
  
  def to_s
    id.to_s
  end
  
  def valid_email?(email)
    TMail::Address.parse(email) && /@/.match(email)
  rescue
    false
  end
  
  validates_each :developer do |record, attr, value|
    record.errors.add("#{attr} entry must be a valid email and") unless record.valid_email?(value)    
  end

  validates_each :dba do |record, attr, value|
    if record.state != Change::STATE_SUGGESTED && !record.valid_email?(value)
      record.errors.add("#{attr} entry must be a valid email and")
    end
  end
  
  private
  
  def check_correct_state
    unless activity.development?
      errors.add_to_base("You can only add or update a change when its activity is in state development")
      false
    end
  end
end
