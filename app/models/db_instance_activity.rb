class DbInstanceActivity < ActiveRecord::Base
  belongs_to :db_instance
  belongs_to :activity
end
