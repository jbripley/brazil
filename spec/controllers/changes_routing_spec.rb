require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChangesController do
  describe "route generation" do

    it "should map { :controller => 'changes', :action => 'index', :app_id => '1', :activity_id => '2' } to /apps/1/activities/2/changes" do
      route_for(:controller => "changes", :action => "index", :app_id => '1', :activity_id => '2').should == "/apps/1/activities/2/changes"
    end
  
    it "should map { :controller => 'changes', :action => 'new' } to /apps/1/activities/2/changes/new" do
      route_for(:controller => "changes", :action => "new", :app_id => '1', :activity_id => '2').should == "/apps/1/activities/2/changes/new"
    end
  
    it "should map { :controller => 'changes', :action => 'show', :id => 1 } to /apps/1/activities/2/changes/1" do
      route_for(:controller => "changes", :action => "show", :id => 1, :app_id => '1', :activity_id => '2').should == "/apps/1/activities/2/changes/1"
    end
  
    it "should map { :controller => 'changes', :action => 'edit', :id => 1 } to /apps/1/activities/2/changes/1/edit" do
      route_for(:controller => "changes", :action => "edit", :id => 1, :app_id => '1', :activity_id => '2').should == "/apps/1/activities/2/changes/1/edit"
    end
  
    it "should map { :controller => 'changes', :action => 'update', :id => 1} to /apps/1/activities/2/changes/1" do
      route_for(:controller => "changes", :action => "update", :id => 1, :app_id => '1', :activity_id => '2').should == "/apps/1/activities/2/changes/1"
    end
   
  end

  describe "route recognition" do

    it "should generate params { :controller => 'changes', action => 'index', :app_id => '1', :activity_id => '2' } from GET /apps/1/activities/2/changes" do
      params_from(:get, "/apps/1/activities/2/changes").should == {:controller => "changes", :action => "index", :app_id => '1', :activity_id => '2'}
    end
  
    it "should generate params { :controller => 'changes', action => 'new', :app_id => '1', :activity_id => '2' } from GET /apps/1/activities/2/changes/new" do
      params_from(:get, "/apps/1/activities/2/changes/new").should == {:controller => "changes", :action => "new", :app_id => '1', :activity_id => '2'}
    end
  
    it "should generate params { :controller => 'changes', action => 'create', :app_id => '1', :activity_id => '2' } from POST /apps/1/activities/2/changes" do
      params_from(:post, "/apps/1/activities/2/changes").should == {:controller => "changes", :action => "create", :app_id => '1', :activity_id => '2'}
    end
  
    it "should generate params { :controller => 'changes', action => 'show', id => '1', :app_id => '1', :activity_id => '2' } from GET /apps/1/activities/2/changes/1" do
      params_from(:get, "/apps/1/activities/2/changes/1").should == {:controller => "changes", :action => "show", :id => "1", :app_id => '1', :activity_id => '2'}
    end
  
    it "should generate params { :controller => 'changes', action => 'edit', id => '1' } from GET /apps/1/activities/2/changes/1/edit" do
      params_from(:get, "/apps/1/activities/2/changes/1/edit").should == {:controller => "changes", :action => "edit", :id => "1", :app_id => '1', :activity_id => '2'}
    end
  
    it "should generate params { :controller => 'changes', action => 'update', id => '1' } from PUT /apps/1/activities/2/changes/1" do
      params_from(:put, "/apps/1/activities/2/changes/1").should == {:controller => "changes", :action => "update", :id => "1", :app_id => '1', :activity_id => '2'}
    end
  
  end
end
