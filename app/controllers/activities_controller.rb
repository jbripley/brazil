class ActivitiesController < ApplicationController
  resource_controller
  belongs_to :app
  
  index.before { @activity = Activity.new(:app_id => params[:app_id]) }
  index.wants.html do
    if request.xhr?
      render :partial => 'index', :locals => {:app => @activity.app, :activities => @activities}
    end
  end
  index.wants.atom

  show.before do
    @change = Change.new(:activity_id => params[:activity_id])
    latest_change = Change.find_by_activity_id_and_state(params[:activity_id], [Change::STATE_EXECUTED, Change::STATE_SAVED], :order => 'created_at DESC')
    if latest_change
      @change.dba = latest_change.dba
      @change.developer = latest_change.developer
    end
  end
  show.wants.html do
    if request.xhr?
      render :partial => "shared/activity", :locals => {:activity => @activity}
    end
  end
  show.wants.atom
  
  [new_action, edit].each { |action| action.wants.html { render :layout => false if request.xhr? } }
  
  create.success.wants.html do
    if request.xhr?
      render :partial => 'shared/activity_row', :collection => @app.activities, :as => 'activity'
    else
      redirect_to app_activity_path(@app, @activity)
    end
  end
  create.failure.wants.html do
    if request.xhr?
      render :partial => 'new', :locals => {:activity => @activity}, :status => :unprocessable_entity
    else
      render :action => "new"
    end
  end
  
  update.success.wants.html do
    if request.xhr?
      render :partial => "shared/activity", :locals => {:activity => @activity}
    else
      redirect_to app_activity_path(@app, @activity)
    end
  end
  update.failure.wants.html do
    if request.xhr?
      render :action => "edit", :layout => false, :status => :unprocessable_entity
    else
      render :action => "edit"
    end
  end
  
  private
  
  def add_controller_crumbs
    add_app_controller_crumbs(parent_object)
    add_activities_controller_crumbs(parent_object, object)
  end
end
