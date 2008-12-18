class App < ActiveRecord::Base
  has_many :activities
  
  validates_presence_of :name
  
  def to_s
    name
  end
end
