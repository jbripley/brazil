class VersionsController < ApplicationController
  helper_method :create_update_sql, :create_rollback_sql

  # GET /apps/:app_id/activities/:activity_id/versions
  # GET /apps/:app_id/activities/:activity_id/versions.xml
  # GET /apps/:app_id/activities/:activity_id/versions.atom
  def index
    @activity = Activity.find(params[:activity_id])
    @versions = @activity.versions.all
    @version = @activity.versions.build

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @versions }
      format.atom # index.atom.builder
    end
  end

  # GET /apps/:app_id/activities/:activity_id/versions/1
  # GET /apps/:app_id/activities/:activity_id/versions/1.xml
  def show
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @version }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/versions/new
  # GET /apps/:app_id/activities/:activity_id/versions/new.xml
  def new
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.build
    @version.update_sql = Change.activity_sql(params[:activity_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @version }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/versions/1/edit
  def edit
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.find(params[:id])
  end

  # POST /apps/:app_id/activities/:activity_id/versions.format
  def create
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.build(params[:version])
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
    @version = @activity.versions.find(params[:id])
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
    @version = @activity.versions.find(params[:id])
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
    @version = @activity.versions.find(params[:id])
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

  # PUT /apps/:app_id/activities/:activity_id/versions/1/deploy.format
  def deploy
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.find(params[:id])

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

  # PUT /apps/:app_id/activities/:activity_id/versions/1/merge
  def merge
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.find(params[:id])
    @version.merge_to_dev(create_update_sql(@version), params[:dev_db_instance_id], params[:dev_schema], params[:db_username], params[:db_password])

    respond_to do |format|
      if @version.errors.empty? && @version.update_attributes(params[:version])
        flash[:notice] = "Version '#{@version}' is now merged"
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

  # GET /apps/:app_id/activities/:activity_id/versions/1/delete
  def delete
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.find(params[:id])
  end

  # DELETE /apps/:app_id/activities/:activity_id/versions/1
  def destroy
    @activity = Activity.find(params[:activity_id])
    @version = @activity.versions.find(params[:id])

    if params[:version_delete_cancel]
      redirect_to app_activity_version_path(@activity.app, @activity, @version)
      return
    end

    respond_to do |format|
      if @version.destroy
        format.html do
          flash[:notice] = "Version '#{@version}' successfully deleted"
          if @activity.versions.count == 0
            @activity.development!
            redirect_to app_activity_path(@activity.app, @activity)
          else
            redirect_to app_activity_versions_path(@activity.app, @activity)
          end
        end
      else
        format.html { render :action => 'delete' }
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
    app = App.find(params[:app_id])
    activity = app.activities.find(params[:activity_id])

    add_app_controller_crumbs(app)
    add_activities_controller_crumbs(app, activity)

    add_crumb 'Versions', app_activity_versions_path(app, activity)

    if params.has_key?(:id)
      version = activity.versions.find(params[:id])
      add_crumb version.to_s, app_activity_version_path(app, activity, version)
    end
  end
end
