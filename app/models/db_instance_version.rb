class DbInstanceVersion < ActiveRecord::Base
  belongs_to :db_instance
  belongs_to :version
end
