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
    
    if params[:create_change_execute_button]
      @change.state = Change::STATE_EXECUTED
    else
      @change.state = Change::STATE_SAVED
    end

    respond_to do |format|
      if @change.valid? && @change.use_sql(params[:change][:sql], params[:db_username], params[:db_password]) && @change.save
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
    
  # GET /apps/:app_id/activities/:activity_id/changes/:change_id/edit
  # GET /apps/:app_id/activities/:activity_id/changes/:change_id/edit.xml  
  def edit
    @change = Change.find(params[:id])
    @change.activity_id = params[:activity_id]

    respond_to do |format|
      format.html do # edit.html.erb
        add_app_crumbs(@change.activity)
        add_crumb 'Edit'
        render :layout => false if request.xhr?
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
    
    if params[:edit_change_execute_button]
      @change.state = Change::STATE_EXECUTED
    else
      @change.state = Change::STATE_SAVED
    end
    
    respond_to do |format|
      if @change.valid? && @change.use_sql(params[:change][:sql], params[:db_username], params[:db_password]) && @change.save
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
