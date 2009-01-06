class VersionsController < ApplicationController
  helper_method :create_update_sql, :create_rollback_sql
  
  resource_controller
  belongs_to :activity
  
  index.wants.atom
  
  new_action.before { object.update_sql = Change.activity_sql(params[:activity_id]) }
  
  # POST /apps/:app_id/activities/:activity_id/versions.format
  def create
    @activity = Activity.find(params[:activity_id])
    
    @version = Version.new(params[:version])
    @version.activity_id = params[:activity_id]
    @version.schema_version = @version.next_schema_version(params[:db_username], params[:db_password])
    
    respond_to do |format|
      if @version.errors.empty? && @version.save
        flash[:notice] = 'Version was successfully created.'
        format.html { redirect_to app_activity_version_path(@activity.app, @activity, @version) }
        format.xml { render :xml => @version, :status => :created, :location => app_activity_version_path(@activity.app, @activity, @version) }
        format.json { render :json => @version, :status => :created, :location => app_activity_version_path(@activity.app, @activity, @version) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
        format.json { render :json => @version.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /apps/:app_id/activities/:activity_id/versions/1.format
  def update
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions(:activity_id => params[:id])
    @version.attributes = params[:version]

    generate_update_sql = Proc.new {create_update_sql(@version)}
    generate_rollback_sql = Proc.new {create_rollback_sql(@version)}

    flash[:notice] = @version.run_sql(generate_update_sql, generate_rollback_sql, params[:db_username], params[:db_password])
  
    respond_to do |format|
      if @version.errors.empty? && @version.save
        format.html { redirect_to app_activity_version_path(@activity.app, @activity, @version) }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
        format.json { render :json => @version.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def create_update_sql(version)
    render_to_string :partial => 'update_sql', :locals => {:version => version}
  end
  
  def create_rollback_sql(version)
    render_to_string :partial => 'rollback_sql', :locals => {:version => version}
  end
  
  def add_controller_crumbs
    add_app_controller_crumbs(parent_object.app)
    add_activities_controller_crumbs(parent_object.app, parent_object)
    
    add_crumb 'Versions', app_activity_versions_path(parent_object.app, parent_object)
    
    if object
      add_crumb object.to_s, app_activity_version_path(parent_object.app, parent_object, object)
    end
  end
end
