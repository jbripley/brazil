require 'schema_version'

class VersionsController < ApplicationController
  add_crumb('Apps') { |instance| instance.send :apps_path }
  helper_method :create_update_sql, :create_rollback_sql
  
  # GET /apps/:app_id/activities/:activity_id/versions
  # GET /apps/:app_id/activities/:activity_id/versions.xml
  # GET /apps/:app_id/activities/:activity_id/versions.atom
  def index
    @version_activities_actionable = Version.find_all_by_activity_id(params[:activity_id], :conditions => {:state => [Version::STATE_CREATED, Version::STATE_TESTED]})
    @version_activities_archived = Version.find_all_by_activity_id(params[:activity_id], :conditions => {:state => Version::STATE_DEPLOYED})
    
    @version = Version.new(:activity_id => params[:activity_id])

    respond_to do |format|
      format.html do # index.html.erb
        add_app_crumbs(@version.activity)
      end
      format.xml  { render :xml => @versions }
      format.atom do # index.atom.builder
        @versions = @version_activities_actionable + @version_activities_archived
      end
    end
  end

  # GET /apps/:app_id/activities/:activity_id/versions/1
  # GET /apps/:app_id/activities/:activity_id/versions/1.xml
  def show
    @version = Version.find(params[:id])
    @version.activity_id = params[:activity_id]
    
    @versioned_update_sql = create_update_sql(@version)
    @versioned_rollback_sql = create_rollback_sql(@version)
    
    respond_to do |format|
      format.html do # show.html.erb
        add_app_crumbs(@version.activity, @version)
        add_crumb @version.to_s
      end
      format.xml  { render :xml => @version }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/versions/new
  # GET /apps/:app_id/activities/:activity_id/versions/new.xml
  def new
    @version = Version.new
    @version.activity_id = params[:activity_id]
    @version.update_sql = merge_change_sql(@version.activity)

    respond_to do |format|
      format.html do # new.html.erb
        add_app_crumbs(@version.activity, @version)
        add_crumb 'New'
      end
      format.xml  { render :xml => @version }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/versions/1/edit
  def edit
    @version = Version.find(params[:id])
    
    respond_to do |format|
      format.html do
        add_app_crumbs(@version.activity, @version)
        add_crumb 'Edit'
      end
    end
  end

  # POST /apps/:app_id/activities/:activity_id/versions
  # POST /apps/:app_id/activities/:activity_id/versions.xml
  def create
    @version = Version.new(params[:version])
    @version.activity_id = params[:activity_id]
    @version.state = Version::STATE_CREATED
    
    found_schema_version = true
    begin
      @version.schema_version = find_schema_version(@version, params[:db_username], params[:db_password]).version.next
    rescue => exception
      found_schema_version = false
      @version.errors.add_to_base("Could not lookup '#{@version.schema}' schema version (#{exception.to_s})")
    end
    
    if @version.activity.state != Activity::STATE_VERSIONED
      @version.activity.state = Activity::STATE_VERSIONED
      @version.activity.save
    end
    
    respond_to do |format|
      if found_schema_version && @version.save
        flash[:notice] = 'Version was successfully created.'
        format.html { redirect_to app_activity_version_path(@version.activity.app, @version.activity, @version) }
        format.xml { render :xml => @version, :status => :created, :location => app_activity_version_path(@version.activity.app, @version.activity, @version) }
      else
        format.html do
          add_app_crumbs(@version.activity, @version)
          add_crumb 'New'
          render :action => "new"
        end
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps/:app_id/activities/:activity_id/versions/1
  # PUT /apps/:app_id/activities/:activity_id/versions/1.xml
  def update
    @version = Version.find(params[:id])
    @version.attributes = params[:version]
    
    found_schema_version = true
    begin
      @version.schema_version = find_schema_version(@version, params[:db_username], params[:db_password]).version.next
    rescue => exception
      found_schema_version = false
      @version.errors.add_to_base("Could not lookup '#{@version.schema}' schema version (#{exception.to_s})")
    end

    respond_to do |format|
      if @version.save
        flash[:notice] = 'Version was successfully updated.'
        format.html { redirect_to app_activity_version_path(@version.activity.app, @version.activity, @version) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/:app_id/activities/:activity_id/versions/1
  # DELETE /apps/:app_id/activities/:activity_id/versions/1.xml
  def destroy
    @version = Version.find(params[:id])
    @version.destroy

    respond_to do |format|
      format.html { redirect_to app_activity_versions_url(@version.activity.app, @version.activity) }
      format.xml  { head :ok }
    end
  end
  
  # PUT /apps/:app_id/activities/:activity_id/versions/1/tested
  # PUT /apps/:app_id/activities/:activity_id/versions/1/tested.xml
  def tested
    @version = Version.find(params[:id])
    
    update_sql_executed = true
    begin
      @version.db_instance_test.execute_sql(create_update_sql(@version), params[:db_username], params[:db_password], @version.schema)
      @version.state = Version::STATE_TESTED
    rescue => exception
      @version.errors.add_to_base("Failed to execute Update SQL (#{exception.to_s})")
      update_sql_executed = false
    end
    
    if update_sql_executed && @version.save
      flash[:notice] = "Executed Update SQL on #{@version.db_instance_test}"
      redirect_to app_activity_version_path(@version.activity.app, @version.activity, @version)
    else
      @versioned_update_sql = create_update_sql(@version)
      @versioned_rollback_sql = create_rollback_sql(@version)
      
      add_app_crumbs(@version.activity, @version)
      add_crumb @version.to_s
      render :action => "show"
    end
  end
  
  # PUT /apps/:app_id/activities/:activity_id/versions/1/deployed
  # PUT /apps/:app_id/activities/:activity_id/versions/1/deployed.xml
  def deployed
    @version = Version.find(params[:id])
    @version.attributes = params[:version]
    @version.state = Version::STATE_DEPLOYED
    @version.save
    
    if @version.activity.state != Activity::STATE_DEPLOYED
      @version.activity.state = Activity::STATE_DEPLOYED
      @version.activity.save
    end
    
    flash[:notice] = "Version '#{@version}' is now set as deployed"
    redirect_to app_activity_versions_path(@version.activity.app, @version.activity)
  end
  
  # PUT /apps/:app_id/activities/:activity_id/versions/1/rollback
  # PUT /apps/:app_id/activities/:activity_id/versions/1/rollback.xml
  def rollback
    @version = Version.find(params[:id])
    
    rollback_sql_executed = true
    begin
      @version.db_instance_test.execute_sql(create_rollback_sql(@version), params[:db_username], params[:db_password], @version.schema)
      @version.state = Version::STATE_CREATED
    rescue => exception
      @version.errors.add_to_base("Failed to execute Rollback SQL (#{exception.to_s})")
      rollback_sql_executed = false
    end
    
    if rollback_sql_executed && @version.save
      flash[:notice] = "Executed Rollback SQL on #{@version.db_instance_test}"
      redirect_to app_activity_version_path(@version.activity.app, @version.activity, @version)
    else
      @versioned_update_sql = create_update_sql(@version)
      @versioned_rollback_sql = create_rollback_sql(@version)
      
      add_app_crumbs(@version.activity, @version)
      add_crumb @version.to_s
      render :action => "show"
    end
  end
  
  private
  
  def find_schema_version(version, db_username, db_password)
    if version.schema.empty?
      raise 'Please enter a Schema to find a schema version for'
    end
    
    version.db_instance_test.find_schema_version(db_username, db_password, version.schema)
  end
  
  def create_update_sql(version)
    schema_version = SchemaVersion.new(version.schema, version.schema_version)
    render_to_string :partial => 'update_sql', :locals => {:version => version, :schema_version => schema_version}
  end
  
  def create_rollback_sql(version)
    schema_version = SchemaVersion.new(version.schema, version.schema_version)
    render_to_string :partial => 'rollback_sql', :locals => {:version => version, :schema_version => schema_version}
  end
  
  def merge_change_sql(activity)
    sql = ''
    Change.find_all_by_activity_id(activity.id, :order => 'created_at').each do |change|
      sql += "#{change.sql}\n"
    end
    sql
  end
  
  def add_app_crumbs(activity, version=nil)
    add_crumb activity.app.to_s
    add_crumb 'Activities', app_activities_path(activity.app)
    add_crumb "#{activity}", app_activity_path(activity.app, activity)
    
    if version.nil?
      add_crumb 'Versions'
    else
      add_crumb 'Versions', app_activity_versions_path(activity.app, activity)
    end
  end
end
