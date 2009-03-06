class ChangesController < ApplicationController
  # GET /apps/:app_id/activities/:activity_id/changes.xml
  def index
    @activity = Activity.find(params[:activity_id])
    @changes = @activity.changes

    respond_to do |format|
      format.xml  { render :xml => @changes }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/changes/1.xml
  def show
    @activity = Activity.find(params[:activity_id])
    @change = @activity.changes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @change }
    end
  end

  # GET /apps/:app_id/activities/:activity_id/changes/new.xml
  def new
    @activity = Activity.find(params[:activity_id])
    @change = @activity.changes.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @change }
    end
  end

  # POST /apps/:app_id/activities/:activity_id/changes.format
  def create
    @activity = Activity.find(params[:activity_id])
    @change = @activity.changes.build(params[:change])

    if params[:create_change_execute_button]
      @change.state = Change::STATE_EXECUTED
    else
      @change.state = Change::STATE_SAVED
    end

    respond_to do |format|
      if @change.valid? && @change.use_sql(@change.sql, params[:db_username], params[:db_password]) && @change.save
        flash[:notice] = 'Database change was successfully created.'
        format.html do
          if request.xhr?
            render :partial => "change", :collection => @activity.changes
          else
            redirect_to app_activity_path(@activity.app, @activity)
          end
        end
        format.xml  { render :xml => @change, :status => :created, :location => app_activity_change_path(@activity.app, @activity, @change) }
        format.json  { render :json => @change, :status => :created, :location => app_activity_change_path(@activity.app, @activity, @change) }
      else
        format.html do
          if request.xhr?
            render :partial => "new", :locals => {:change => @change, :activity => @activity}, :status => :unprocessable_entity
          else
            render :action => "new"
          end
        end
        format.xml  { render :xml => @change.errors, :status => :unprocessable_entity }
        format.json  { render :json => @change.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /apps/:app_id/activities/:activity_id/changes/:change_id/edit
  # GET /apps/:app_id/activities/:activity_id/changes/:change_id/edit.xml
  def edit
    @activity = Activity.find(params[:activity_id])
    @change = @activity.changes.find(params[:id])

    respond_to do |format|
      format.html do # edit.html.erb
        render :layout => false if request.xhr?
      end
      format.xml  { render :xml => @change }
    end
  end

  # PUT /apps/:app_id/activities/:activity_id/changes/:id.format
  def update
    @activity = Activity.find(params[:activity_id])
    @change = @activity.changes.find(params[:id])
    @change.attributes = params[:change]

    if params[:edit_change_execute_submit]
      @change.state = Change::STATE_EXECUTED
    else
      @change.state = Change::STATE_SAVED
    end

    respond_to do |format|
      if @change.valid? && @change.use_sql(@change.sql, params[:db_username], params[:db_password]) && @change.save
        flash[:notice] = 'Change was successfully updated.'
        format.html do
          if request.xhr?
            render :partial => "change", :collection => @activity.changes
          else
            redirect_to app_activity_path(@activity.app, @activity)
          end
        end
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html do
          if request.xhr?
            render :action => "edit", :layout => false, :status => :unprocessable_entity
          else
            render :action => "edit"
          end
        end
        format.xml  { render :xml => @change.errors, :status => :unprocessable_entity }
        format.json  { render :json => @change.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def add_controller_crumbs
    app = App.find(params[:app_id])
    add_app_controller_crumbs(app)
    add_activities_controller_crumbs(app, app.activities.find(params[:activity_id]))

    add_crumb 'Changes'

    if params.has_key?(:id)
      add_crumb app.activities.find(params[:activity_id]).changes.find(params[:id]).to_s
    end
  end
end
