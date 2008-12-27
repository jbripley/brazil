class VersionsController < ApplicationController
  add_crumb('Apps') { |instance| instance.send :apps_path }
  helper_method :create_update_sql, :create_rollback_sql
  
  # GET /apps/:app_id/activities/:activity_id/versions
  # GET /apps/:app_id/activities/:activity_id/versions.xml
  # GET /apps/:app_id/activities/:activity_id/versions.atom
  def index
    @versions = Version.find_all_by_activity_id(params[:activity_id])
    @version = Version.new(:activity_id => params[:activity_id])

    respond_to do |format|
      format.html do # index.html.erb
        add_app_crumbs(@version.activity)
      end
      format.xml  { render :xml => @versions }
      format.atom # index.atom.builder
    end
  end

  # GET /apps/:app_id/activities/:activity_id/versions/1
  # GET /apps/:app_id/activities/:activity_id/versions/1.xml
  def show
    @version = Version.find(params[:id])
    @version.activity_id = params[:activity_id]
    
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
    @version.update_sql = Change.activity_sql(params[:activity_id])

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
    @version.created!
    @version.schema_version = @version.next_schema_version(params[:db_username], params[:db_password])
    
    respond_to do |format|
      if @version.errors.empty? && @version.save
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

    flash[:notice] = @version.run_sql(create_update_sql(@version), create_rollback_sql(@version), params[:db_username], params[:db_password])

    respond_to do |format|
      if @version.errors.empty? && @version.save
        format.html { redirect_to app_activity_version_path(@version.activity.app, @version.activity, @version) }
        format.xml  { head :ok }
      else
        format.html do
          add_app_crumbs(@version.activity, @version)
          add_crumb @version.to_s
          render :action => 'edit'
        end
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
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
