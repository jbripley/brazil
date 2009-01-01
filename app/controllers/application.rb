# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '625a1da328413bd87823be9284ab71f6'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :db_password
  
  add_crumb 'Home', '/'
  
  before_filter :add_controller_crumbs, :except => :destroy
  before_filter(:only => :new) { |controller| controller.add_crumb('New') }
  before_filter(:only => :edit) { |controller| controller.add_crumb('Edit') }
  
  private

  def add_app_controller_crumbs(app_model)
    add_crumb 'Apps', apps_path
    add_crumb app_model.to_s
  end
  
  def add_activities_controller_crumbs(app_model, activity_model=nil)
    add_crumb 'Activities', app_activities_path(app_model)
    
    if activity_model
      add_crumb activity_model.to_s, app_activity_path(app_model, activity_model)
    end
  end
end
