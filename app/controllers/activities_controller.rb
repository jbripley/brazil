class ActivitiesController < ApplicationController
  # GET /apps/:app_id/activities
  # GET /apps/:app_id/activities.xml
  # GET /apps/:app_id/activities.atom
  def index
    @app = App.find(params[:app_id])
    @activities = @app.activities.all(:order => 'updated_at DESC')
    @activity = @app.activities.build

    respond_to do |format|
      format.html do # index.html.erb
        if request.xhr?
          render :partial => 'index', :locals => {:app => @app, :activities => @activities}
        end
      end
      format.xml  { render :xml => @activities }
      format.atom # index.atom.builder
    end
  end

  # GET /apps/:app_id/activities/1
  # GET /apps/:app_id/activities/1.xml
  # GET /apps/:app_id/activities/1.atom
  def show
    @app = App.find(params[:app_id])
    @activity = @app.activities.find(params[:id])
    @change = @activity.changes.build

    latest_change = Change.first(:conditions => {:activity_id => params[:id], :state => [Change::STATE_EXECUTED, Change::STATE_SAVED]}, :order => 'created_at DESC')
    if latest_change
      @change.dba = latest_change.dba
      @change.developer = latest_change.developer
    end

    respond_to do |format|
      format.html do # show.html.erb
        if request.xhr?
          render :partial => "shared/activity", :locals => {:activity => @activity}
        end
      end
      format.xml  { render :xml => @activity }
      format.atom # show.atom.builder
    end
  end

  # GET /apps/:app_id/activities/new
  # GET /apps/:app_id/activities/new.xml
  def new
    @app = App.find(params[:app_id])
    @activity = @app.activities.build

    respond_to do |format|
      format.html do # new.html.erb
        render :layout => false if request.xhr?
      end
      format.xml  { render :xml => @activity }
    end
  end

  # GET /apps/:app_id/activities/1/edit
  def edit
    @app = App.find(params[:app_id])
    @activity = @app.activities.find(params[:id])
    render :layout => false if request.xhr?
  end

  # POST /apps/:app_id/activities
  # POST /apps/:app_id/activities.xml
  def create
    @app = App.find(params[:app_id])
    @activity = @app.activities.build(params[:activity])
    @activity.state = Activity::STATE_DEVELOPMENT

    respond_to do |format|
      if @activity.save
        flash[:notice] = 'Activity was successfully created.'
        format.html do
          if request.xhr?
            render :partial => 'shared/activity_row', :collection => @app.activities, :as => 'activity'
          else
            redirect_to app_activity_path(@app, @activity)
          end
        end
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html do
          if request.xhr?
            render :partial => 'new', :locals => {:activity => @activity, :app => @app}, :status => :unprocessable_entity
          else
            render :action => "new"
          end
        end
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps/:app_id/activities/1
  # PUT /apps/:app_id/activities/1.xml
  def update
    @app = App.find(params[:app_id])
    @activity = @app.activities.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        flash[:notice] = 'Activity was successfully updated.'
        format.html do
          if request.xhr?
            render :partial => "shared/activity", :locals => {:activity => @activity}
          else
            redirect_to app_activity_path(@app, @activity)
          end
        end
        format.xml  { head :ok }
      else
        format.html do
          if request.xhr?
            render :action => "edit", :layout => false, :status => :unprocessable_entity
          else
            render :action => "edit"
          end
        end
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def add_controller_crumbs
    app = App.find(params[:app_id])
    add_app_controller_crumbs(app)

    if params.has_key?(:id)
      add_activities_controller_crumbs(app, app.activities.find(params[:id]))
    else
      add_activities_controller_crumbs(app, nil)
    end
  end
end
