class AppsController < ApplicationController
  add_crumb('Apps') { |instance| instance.send :apps_path }
  
  # GET /apps
  # GET /apps.xml
  # GET /apps.atom
  def index
    @apps = App.find(:all)
    @app = App.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @apps }
      format.atom # index.atom.builder
    end
  end

  # GET /apps/1
  # GET /apps/1.xml
  def show
    @app = App.find(params[:id])

    respond_to do |format|
      format.html do # show.html.erb
        if request.xhr?
          render :partial => 'app', :locals => {:app => @app}
        end
      end
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.xml
  def new
    @app = App.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find(params[:id])
    
    respond_to do |format|
      format.html do
        if request.xhr?
          render :partial => 'edit_min', :locals => {:app => @app}
        end
      end
    end
  end

  # POST /apps
  # POST /apps.xml
  def create
    @app = App.new(params[:app])

    respond_to do |format|
      if @app.save
        flash[:notice] = 'App was successfully created.'
        format.html { redirect_to app_activities_path(@app) }
        format.xml  { render :xml => @app, :status => :created, :location => @app }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.xml
  def update
    @app = App.find(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html do
          if request.xhr?
            render :partial => 'app', :locals => {:app => @app}
          else
            flash[:notice] = 'App was successfully updated.'
            redirect_to app_activities_path(@app)
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.xml
  def destroy
    @app = App.find(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to(apps_url) }
      format.xml  { head :ok }
    end
  end
end
