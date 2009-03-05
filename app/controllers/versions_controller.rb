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
    @version.init_schema_version(params[:db_username], params[:db_password])

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

  # PUT /apps/:app_id/activities/:activity_id/versions.format
  def update
    @activity = Activity.find(params[:activity_id])
    @version = Version.find(params[:id])
    @version.attributes = params[:version]

    updated_schema_version = [params[:schema_version_major], params[:schema_version_minor], params[:schema_version_patch]].join('_')
    @version.update_schema_version(updated_schema_version, params[:db_username], params[:db_password])

    respond_to do |format|
      if @version.errors.empty? && @version.save
        flash[:notice] = 'Version was successfully updated.'
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

  # PUT /apps/:app_id/activities/:activity_id/versions/1/test.format
  def test
    @activity = Activity.find(params[:activity_id])
    @version = Version.find(params[:id])
    @version.deploy_to_test(create_update_sql(@version), create_rollback_sql(@version), params[:db_username], params[:db_password], params[:vc_username], params[:vc_password])

    respond_to do |format|
      if @version.errors.empty? && @version.update_attributes(params[:version])
        flash[:notice] = "Executed Update SQL on #{@version.db_instance_test}"
        format.html { redirect_to app_activity_version_path(@activity.app, @activity, @version) }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        flash[:error] = "Failed to execute Update SQL"
        format.html { render :action => 'show' }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
        format.json { render :json => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps/:app_id/activities/:activity_id/versions/1/rollback.format
  def rollback
    @activity = Activity.find(params[:activity_id])
    @version = Version.find(params[:id])
    @version.rollback_from_test(create_rollback_sql(@version), params[:db_username], params[:db_password], params[:vc_username], params[:vc_password])

    respond_to do |format|
      if @version.errors.empty? && @version.update_attributes(params[:version])
        flash[:notice] = "Executed Rollback SQL on #{@version.db_instance_test}"
        format.html { redirect_to app_activity_version_path(@activity.app, @activity, @version) }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        flash[:error] = "Failed to execute Rollback SQL"
        format.html { render :action => 'show' }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
        format.json { render :json => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  def deployed
    @activity = Activity.find(params[:activity_id])
    @version = Version.find(params[:id])

    respond_to do |format|
      if @version.update_attributes(params[:version])
        @activity.deployed!
        flash[:notice] = "Version '#{@version}' is now set as deployed"
        format.html { redirect_to app_activity_version_path(@activity.app, @activity, @version) }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => 'show' }
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
