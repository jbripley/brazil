class ChangesController < ApplicationController
  resource_controller
  belongs_to :activity
  
  # POST /apps/:app_id/activities/:activity_id/changes.format
  def create
    @change = Change.new(params[:change])
    @change.activity_id = params[:activity_id]
    
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
            render :partial => "change", :collection => @change.activity.changes
          else
            redirect_to app_activity_path(@change.activity.app, @change.activity)
          end
        end
        format.xml  { render :xml => @change, :status => :created, :location => app_activity_change_path(@change.activity.app, @change.activity, @change) }
        format.json  { render :json => @change, :status => :created, :location => app_activity_change_path(@change.activity.app, @change.activity, @change) }
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
  
  edit.wants.html { render :layout => false if request.xhr? }
    
  # PUT /apps/:app_id/activities/:activity_id/changes/:id.format
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
      if @change.valid? && @change.use_sql(@change.sql, params[:db_username], params[:db_password]) && @change.save
        flash[:notice] = 'Change was successfully updated.'
        format.html do
          if request.xhr?
            render :partial => "change", :collection => @change.activity.changes
          else
            redirect_to app_activity_path(@change.activity.app, @change.activity)
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
    add_app_controller_crumbs(parent_object.app)
    add_activities_controller_crumbs(parent_object.app, parent_object)
    
    add_crumb 'Changes'
    
    if object
      add_crumb object.to_s
    end
  end
end
