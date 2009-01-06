require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VersionsController do
  describe "route generation" do

    it "should map { :controller => 'versions', :action => 'index' } to /apps/3/activities/3/versions" do
      route_for(:controller => "versions", :action => "index", :app_id => '3', :activity_id => '3').should == "/apps/3/activities/3/versions"    end
  
    it "should map { :controller => 'versions', :action => 'new' } to /apps/3/activities/3/versions/new" do
      route_for(:controller => "versions", :action => "new", :app_id => '3', :activity_id => '3').should == "/apps/3/activities/3/versions/new"
    end
  
    it "should map { :controller => 'versions', :action => 'show', :id => 1 } to /apps/3/activities/3/versions/1" do
      route_for(:controller => "versions", :action => "show", :id => 1, :app_id => '3', :activity_id => '3').should == "/apps/3/activities/3/versions/1"
    end
  
    it "should map { :controller => 'versions', :action => 'edit', :id => 1 } to /apps/3/activities/3/versions/1/edit" do
      route_for(:controller => "versions", :action => "edit", :id => 1, :app_id => '3', :activity_id => '3').should == "/apps/3/activities/3/versions/1/edit"
    end
  
    it "should map { :controller => 'versions', :action => 'update', :id => 1} to /apps/3/activities/3/versions/1" do
      route_for(:controller => "versions", :action => "update", :id => 1, :app_id => '3', :activity_id => '3').should == "/apps/3/activities/3/versions/1"
    end
    
  end

  describe "route recognition" do

    it "should generate params { :controller => 'versions', action => 'index' } from GET /apps/3/activities/3/versions" do
      params_from(:get, "/apps/3/activities/3/versions").should == {:controller => "versions", :action => "index", :app_id => '3', :activity_id => '3'}
    end
  
    it "should generate params { :controller => 'versions', action => 'new' } from GET /apps/3/activities/3/versions/new" do
      params_from(:get, "/apps/3/activities/3/versions/new").should == {:controller => "versions", :action => "new", :app_id => '3', :activity_id => '3'}
    end
  
    it "should generate params { :controller => 'versions', action => 'create' } from POST /apps/3/activities/3/versions" do
      params_from(:post, "/apps/3/activities/3/versions").should == {:controller => "versions", :action => "create", :app_id => '3', :activity_id => '3'}
    end
  
    it "should generate params { :controller => 'versions', action => 'show', id => '1' } from GET /apps/3/activities/3/versions/1" do
      params_from(:get, "/apps/3/activities/3/versions/1").should == {:controller => "versions", :action => "show", :id => "1", :app_id => '3', :activity_id => '3'}
    end
  
    it "should generate params { :controller => 'versions', action => 'edit', id => '1' } from GET /apps/3/activities/3/versions/1;edit" do
      params_from(:get, "/apps/3/activities/3/versions/1/edit").should == {:controller => "versions", :action => "edit", :id => "1", :app_id => '3', :activity_id => '3'}
    end
  
    it "should generate params { :controller => 'versions', action => 'update', id => '1' } from PUT /apps/3/activities/3/versions/1" do
      params_from(:put, "/apps/3/activities/3/versions/1").should == {:controller => "versions", :action => "update", :id => "1", :app_id => '3', :activity_id => '3'}
    end
    
  end
end
