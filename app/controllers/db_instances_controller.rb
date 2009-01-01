class DbInstancesController < ApplicationController
  resource_controller
  
  private
  
  def add_controller_crumbs
    add_crumb 'Database Instances', db_instances_path
    
    if object
      add_crumb object.to_s, db_instance_path(object)
    end
  end
end
