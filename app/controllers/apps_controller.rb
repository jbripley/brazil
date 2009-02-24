class AppsController < ApplicationController
  resource_controller

  index.before { @app = App.new }
  index.wants.atom

  show.wants.html do
    if request.xhr?
      render :partial => 'app', :locals => {:app => @app}
    end
  end

  create.wants.html do
    redirect_to app_activities_path(@app)
  end

  edit.wants.html do
    if request.xhr?
      render :partial => 'edit_horizontal', :locals => {:app => @app}
    end
  end

  update do
    success.wants.html do
      if request.xhr?
        render :partial => 'app', :locals => {:app => @app}
      else
        redirect_to app_activities_path(@app)
      end
    end
    failure.wants.html do
      if request.xhr?
        render :partial => 'edit_name', :locals => {:app => @app}
      else
        render :action => 'edit'
      end
    end
  end

  private

  def add_controller_crumbs
    add_crumb 'Apps', apps_path

    if object
      add_crumb object.to_s, app_path(object)
    end
  end
end
