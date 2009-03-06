class ChangeSuggestionsController < ApplicationController
  # GET /apps/:app_id/activities/:activity_id/change_suggestions/new
  # GET /apps/:app_id/activities/:activity_id/change_suggestions/new.xml
  def new
    @activity = Activity.find(params[:activity_id])
    @change = @activity.changes.build

    respond_to do |format|
      format.html do # new.html.erb
        render :layout => false if request.xhr?
      end
      format.xml  { render :xml => @change }
    end
  end

  # POST /apps/:app_id/activities/:activity_id/change_suggestions
  def create
    @activity = Activity.find(params[:activity_id])
    @change = @activity.changes.build(params[:change])
    @change.state = Change::STATE_SUGGESTED

    respond_to do |format|
      if @change.save
        flash[:notice] = 'Change suggestion was successfully created.'
        format.html do
          if request.xhr?
            render :partial => "changes/change", :collection => @activity.changes
          else
            redirect_to app_activity_path(@activity.app, @activity)
          end
        end
      else
        format.html do
          if request.xhr?
            render :action => 'new', :layout => false, :status => :unprocessable_entity
          else
            render :action => "new"
          end
        end
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

    add_crumb 'Change Suggestions'
  end
end
