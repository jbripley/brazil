class ChangesController < ApplicationController
  add_crumb('Apps') { |instance| instance.send :apps_path }
  
  # GET /apps/:app_id/activities/:activity_id/changes.xml
  def index
    @changes = Change.find_all_by_activity_id(params[:activity_id])

    respond_to do |format|
      format.xml  { render :xml => @changes }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/changes/1.xml
  def show
    @change = Change.find(params[:id])

    respond_to do |format|
      format.html do # show.html.erb
        add_app_crumbs(@change.activity)
        add_crumb @change.to_s
      end
      format.xml  { render :xml => @change }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/changes/new.xml
  def new
    @change = Change.new(:activity_id => params[:activity_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change }
    end
  end

  # POST /apps/:app_id/activities/:activity_id/changes
  # POST /apps/:app_id/activities/:activity_id/changes.xml
  def create
    @change = Change.new(params[:change])
    @change.activity_id = params[:activity_id]

    @change.activity.updated_at = Time.now
    @change.activity.save
    
    proc_execute_change_sql = setup_change_execution(@change, params[:commit], params[:change][:sql], params[:db_username], params[:db_password])
    
    respond_to do |format|
      if @change.valid? && proc_execute_change_sql.call && @change.save
        flash[:notice] = 'Database change was successfully created.'
        format.html do
          if request.xhr?
            render :partial => "change", :collection => @change.activity.changes
          else
            redirect_to app_activity_path(@change.activity.app, @change.activity)
          end
        end
        format.xml  { render :xml => @change, :status => :created, :location => app_activity_change_path(@change.activity.app, @change.activity, @change) }
      else
        format.html do
          if request.xhr?
            render :partial => "changes/new", :locals => {:change => @change}, :status => :unprocessable_entity
          else
            add_app_crumbs(@change.activity)
            add_crumb 'New'
            render :action => "new"
          end
        end
        format.xml  { render :xml => @change.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /apps/:app_id/activities/:activity_id/changes/suggest_new  
  # GET /apps/:app_id/activities/:activity_id/changes/suggest_new.xml
  def suggest_new
    @change = Change.new(:activity_id => params[:activity_id])
    
    respond_to do |format|
      format.html do # suggest_new.html.erb
        if request.xhr?
          render :partial => "suggest_new", :locals => {:change => @change}
        else
          add_app_crumbs(@change.activity)
          add_crumb 'Suggest New'
        end          
      end
      format.xml  { render :xml => @change }
    end
  end

  # POST /apps/:app_id/activities/:activity_id/changes/suggest
  def suggest
    @change = Change.new(params[:change])
    @change.activity_id = params[:activity_id]
    @change.state = Change::STATE_SUGGESTED
    
    if params[:commit] == 'Cancel'
      redirect_to app_activity_path(@change.activity.app, @change.activity)
      return
    end
   
    respond_to do |format|
      if @change.save
        flash[:notice] = 'Change suggestion was successfully created.'
        format.html do
          if request.xhr?
            render :partial => "change", :collection => @change.activity.changes
          else
            redirect_to app_activity_path(@change.activity.app, @change.activity)
          end
        end
      else
        format.html do
          if request.xhr?
            render :partial => "suggest_new", :locals => {:change => @change}, :status => :unprocessable_entity
          else
            add_app_crumbs(@change.activity)
            add_crumb 'Suggest New'
            render :action => "suggest_new"
          end
        end
      end
    end
  end
  
  # GET /apps/:app_id/activities/:activity_id/changes/:change_id/edit
  # GET /apps/:app_id/activities/:activity_id/changes/:change_id/edit.xml  
  def edit
    @change = Change.find(params[:id])
    @change.activity_id = params[:activity_id]
    
    respond_to do |format|
      format.html do # edit.html.erb
        if request.xhr?
          render :partial => 'edit', :locals => {:change => @change}
        else
          add_app_crumbs(@change.activity)
          add_crumb 'Edit'
        end          
      end
      format.xml  { render :xml => @change }
    end
  end
  
  # PUT /apps/:app_id/activities/:activity_id/changes/:id
  # PUT /apps/:app_id/activities/:activity_id/changes/:id.xml
  def update
    @change = Change.find(params[:id ])
    @change.activity_id = params[:activity_id]
    @change.attributes = params[:change]

    @change.activity.updated_at = Time.now    
    @change.activity.save
    
    proc_execute_change_sql = setup_change_execution(@change, params[:commit], params[:change][:sql], params[:db_username], params[:db_password])
    
    respond_to do |format|
      if @change.valid? && proc_execute_change_sql.call && @change.save
        flash[:notice] = 'Change was successfully updated.'
        format.html do
          if request.xhr?
            render :partial => "change", :collection => @change.activity.changes
          else
            redirect_to app_activity_path(@change.activity.app, @change.activity)
          end
        end
        format.xml  { head :ok }
      else
        format.html do
          if request.xhr?
            render :partial => "edit", :locals => {:change => @change}, :status => :unprocessable_entity
          else
            add_app_crumbs(@change.activity, @change)
            add_crumb 'Edit'
            render :action => "edit"
          end
        end
        format.xml  { render :xml => @change.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def setup_change_execution(change, execute_sql, sql, db_username, db_password)
    if execute_sql
      change.state = Change::STATE_EXECUTED
      proc_execute_change_sql = Proc.new do
        execute_change_sql(change, sql, db_username, db_password)
      end
    else
      change.state = Change::STATE_SAVED
      proc_execute_change_sql = Proc.new do
        check_change_db_credentials(change, db_username, db_password)
      end
    end
  end
  
  def execute_change_sql(change, sql, db_username, db_password)
    db_instance_dev = change.activity.db_instance_dev
    begin
      if db_instance_dev
        db_instance_dev.execute_sql(sql, db_username, db_password, change.activity.schema)
        return true
      else
        raise "#{change.activity} has no #{DbInstance.KIND_DEV} database instance set. Use Edit Activity to set one."
      end
    rescue => exception
      change.errors.add(:sql, "not executed: #{exception.to_s}")
      return false
    end
  end
  
  def check_change_db_credentials(change, db_username, db_password)
    db_instance_dev = change.activity.db_instance_dev
    begin
      if db_instance_dev
        db_instance_dev.check_db_credentials(db_username, db_password, change.activity.schema)
      else
        raise "#{change.activity} has no #{DbInstance.KIND_DEV} database instance set. Use Edit Activity to set one."
      end
    rescue => exception
      change.errors.add_to_base("You don't have the Database credentials to save this change")
      return false
    end
  end
  
  def add_app_crumbs(activity, change=nil)
    add_crumb activity.app.to_s
    add_crumb 'Activities', app_activities_path(activity.app)
    add_crumb "#{activity}", app_activity_path(activity.app, activity)
    
    if change.nil?
      add_crumb 'Changes'
    else
      add_crumb 'Changes', app_activity_changes_path(activity.app, activity)
    end
  end
end
