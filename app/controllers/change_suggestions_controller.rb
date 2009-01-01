class ChangeSuggestionsController < ApplicationController
  resource_controller
  belongs_to :activity
  
  new_action.before { @change = object }
  new_action.wants.html { render :layout => false if request.xhr? }
  
  create.success.wants.html do
    if request.xhr?
      render :partial => "changes/change", :collection => @activity.changes
    else
      redirect_to app_activity_path(@activity.app, @activity)
    end
  end
  create.failure.wants.html do
    if request.xhr?
      render :action => 'new', :layout => false, :status => :unprocessable_entity
    else
      render :action => "new"
    end
  end
  
  private
    
  def build_object
    @object ||= Change.new(params[:change])
    @object.activity_id = params[:activity_id]
  end
  
  private
  
  def add_controller_crumbs
    add_app_controller_crumbs(parent_object.app)
    add_activities_controller_crumbs(parent_object.app, parent_object)
    
    add_crumb 'Change Suggestions'
  end
end
