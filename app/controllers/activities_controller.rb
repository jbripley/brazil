class ActivitiesController < ApplicationController
  add_crumb('Apps') { |instance| instance.send :apps_path }
  
  # GET /apps/:app_id/activities
  # GET /apps/:app_id/activities.xml
  # GET /apps/:app_id/activities.atom  
  def index
    @activities = Activity.find_all_by_app_id(params[:app_id], :order => 'updated_at desc')
    @activity = Activity.new(:app_id => params[:app_id])

    respond_to do |format|
      format.html do # index.html.erb
        add_app_crumbs(@activity.app)
      end
      format.xml  { render :xml => @activities }
      format.atom # index.atom.builder
    end
  end

  # GET /apps/:app_id/activities/1
  # GET /apps/:app_id/activities/1.xml
  # GET /apps/:app_id/activities/1.atom
  def show
    @activity = Activity.find(params[:id])
    @change = Change.new(:activity_id => @activity.id)
    
    latest_change = Change.find_by_activity_id_and_state(@activity.id, [Change::STATE_EXECUTED, Change::STATE_SAVED], :order => 'created_at DESC')
    if latest_change
      @change.dba = latest_change.dba
      @change.developer = latest_change.developer
    end

    respond_to do |format|
      format.html do # show.html.erb
        unless request.xhr?
          add_app_crumbs(@activity.app, @activity)
          add_crumb @activity.to_s
        else
          render :partial => "show", :locals => {:activity => @activity}
        end
      end
      format.xml  { render :xml => @activity }
      format.atom # show.atom.builder
    end
  end

  # GET /apps/:app_id/activities/new
  # GET /apps/:app_id/activities/new.xml
  def new
    @activity = Activity.new
    @activity.app_id = params[:app_id]
    
    respond_to do |format|
      format.html do # new.html.erb
        if request.xhr?
          render :partial => "new", :locals => {:activity => @activity}
        else
          add_app_crumbs(@activity.app, @activity)
          add_crumb 'New'
        end
      end
      format.xml  { render :xml => @activity }
    end
  end

  # GET /apps/:app_id/activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
    
    if request.xhr?
      render :partial => "edit", :locals => {:activity => @activity}
    else
      add_app_crumbs(@activity.app, @activity)
      add_crumb @activity.to_s, app_activity_path(@activity.app, @activity)
      add_crumb "Edit"
    end
  end

  # POST /apps/:app_id/activities
  # POST /apps/:app_id/activities.xml
  def create
    @activity = Activity.new(params[:activity])
    @activity.app_id = params[:app_id]
    @activity.state = Activity::STATE_DEVELOPMENT
    
    respond_to do |format|
      if @activity.save
        flash[:notice] = 'Activity was successfully created.'
        format.html do
          if request.xhr?
            render :partial => 'shared/activity_index', :collection => @activity.app.activities, :as => 'activity'
          else
            redirect_to app_activity_path(@activity.app, @activity)
          end
        end
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html do
          if request.xhr?
            render :partial => 'new', :locals => {:activity => @activity}, :status => :unprocessable_entity
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
    @activity = Activity.find(params[:id])
    
    if params[:activity_edit_cancel_button]
      redirect_to app_activity_path(@activity.app, @activity)
      return
    end
      
    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        flash[:notice] = 'Activity was successfully updated.'
        format.html do
          if request.xhr?
            render :partial => "show", :locals => {:activity => @activity}
          else
            redirect_to app_activity_path(@activity.app, @activity)
          end
        end
        format.xml  { head :ok }
      else
        format.html do
          if request.xhr?
            render :partial => "edit", :locals => {:activity => @activity}, :status => :unprocessable_entity
          else
            render :action => "edit"
          end
        end
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def add_app_crumbs(app, activity=nil)
    add_crumb "#{app}"
    
    if activity.nil?
      add_crumb 'Activities'
    else
      add_crumb 'Activities', app_activities_path(activity.app)
    end
  end
end
