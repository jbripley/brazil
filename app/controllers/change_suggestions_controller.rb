class ChangeSuggestionsController < ApplicationController
  add_crumb('Apps') { |instance| instance.send :apps_path }
  
  # GET /apps/:app_id/activities/:activity_id/change_suggestions/new
  # GET /apps/:app_id/activities/:activity_id/change_suggestions/new.xml
  def new
    @change = Change.new(:activity_id => params[:activity_id])

    respond_to do |format|
      format.html do # new.html.erb
        add_app_crumbs(@change.activity)
        add_crumb 'New'
        render :layout => false if request.xhr?
      end
      format.xml  { render :xml => @change }
    end
  end

  # POST /apps/:app_id/activities/:activity_id/change_suggestions
  def create
    @change = Change.new(params[:change])
    @change.activity_id = params[:activity_id]
    @change.state = Change::STATE_SUGGESTED
    
    respond_to do |format|
      if @change.save
        flash[:notice] = 'Change suggestion was successfully created.'
        format.html do
          if request.xhr?
            render :partial => "changes/change", :collection => @change.activity.changes
          else
            redirect_to app_activity_path(@change.activity.app, @change.activity)
          end
        end
      else
        format.html do
          if request.xhr?
            render :action => 'new', :layout => false, :status => :unprocessable_entity
          else
            add_app_crumbs(@change.activity)
            add_crumb 'New'
            render :action => "new"
          end
        end
      end
    end
  end

  private

  def add_app_crumbs(activity, change=nil)
    add_crumb activity.app.to_s
    add_crumb 'Activities', app_activities_path(activity.app)
    add_crumb "#{activity}", app_activity_path(activity.app, activity)

    if change.nil?
      add_crumb 'Change Suggestions'
    else
      add_crumb 'Change Suggestions', app_activity_suggestions_path(activity.app, activity)
    end
  end

end
