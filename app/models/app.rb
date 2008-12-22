class App < ActiveRecord::Base
  has_many :activities, :order => 'updated_at DESC'
  
  validates_presence_of :name
  
  def to_s
    name
  end
end
