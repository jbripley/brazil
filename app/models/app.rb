class App < ActiveRecord::Base
  has_many :activities, :order => 'updated_at DESC'

  validates_presence_of :name, :vc_path

  def to_s
    name
  end
end
