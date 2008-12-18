module DbInstancesHelper
  def db_types
    DbInstance.db_types
  end
  
  def db_environments
    DbInstance.db_environments
  end
  
  def db_instances_of_environment(db_env)
    DbInstance.find_all_by_db_env(db_env)
  end
end
