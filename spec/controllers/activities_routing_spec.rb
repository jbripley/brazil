require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivitiesController do
  describe "route generation" do

    it "should map { :controller => 'activities', :action => 'index' } to /apps/:app_id/activities" do
      route_for(:controller => "activities", :action => "index", :app_id => 1).should == "/apps/1/activities"
    end
  
    it "should map { :controller => 'activities', :action => 'new' } to /apps/:app_id/activities/new" do
      route_for(:controller => "activities", :action => "new", :app_id => 1).should == "/apps/1/activities/new"
    end
  
    it "should map { :controller => 'activities', :action => 'show', :id => 1 } to /apps/:app_id/activities/1" do
      route_for(:controller => "activities", :action => "show", :id => 1, :app_id => 1).should == "/apps/1/activities/1"
    end
  
    it "should map { :controller => 'activities', :action => 'edit', :id => 1 } to /apps/:app_id/activities/1/edit" do
      route_for(:controller => "activities", :action => "edit", :id => 1, :app_id => 1).should == "/apps/1/activities/1/edit"
    end
  
    it "should map { :controller => 'activities', :action => 'update', :id => 1} to /apps/:app_id/activities/1" do
      route_for(:controller => "activities", :action => "update", :id => 1, :app_id => 1).should == "/apps/1/activities/1"
    end
  
  end

  describe "route recognition" do

    it "should generate params { :controller => 'activities', action => 'index' } from GET /apps/:app_id/activities" do
      params_from(:get, "/apps/1/activities").should == {:controller => "activities", :action => "index", :app_id => '1'}
    end
  
    it "should generate params { :controller => 'activities', action => 'new' } from GET /apps/:app_id/activities/new" do
      params_from(:get, "/apps/1/activities/new").should == {:controller => "activities", :action => "new", :app_id => '1'}
    end
  
    it "should generate params { :controller => 'activities', action => 'create' } from POST /apps/:app_id/activities" do
      params_from(:post, "/apps/1/activities").should == {:controller => "activities", :action => "create", :app_id => '1'}
    end
  
    it "should generate params { :controller => 'activities', action => 'show', id => '1' } from GET /apps/:app_id/activities/1" do
      params_from(:get, "/apps/1/activities/1").should == {:controller => "activities", :action => "show", :id => "1", :app_id => '1'}
    end
  
    it "should generate params { :controller => 'activities', action => 'edit', id => '1' } from GET /apps/:app_id/activities/1;edit" do
      params_from(:get, "/apps/1/activities/1/edit").should == {:controller => "activities", :action => "edit", :id => "1", :app_id => '1'}
    end
  
    it "should generate params { :controller => 'activities', action => 'update', id => '1' } from PUT /apps/:app_id/activities/1" do
      params_from(:put, "/apps/1/activities/1").should == {:controller => "activities", :action => "update", :id => "1", :app_id => '1'}
    end
  
  end
end
