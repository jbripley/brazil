require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AppsController do
  describe "route generation" do

    it "should map { :controller => 'apps', :action => 'index' } to /apps" do
      route_for(:controller => "apps", :action => "index").should == "/apps"
    end
  
    it "should map { :controller => 'apps', :action => 'new' } to /apps/new" do
      route_for(:controller => "apps", :action => "new").should == "/apps/new"
    end
  
    it "should map { :controller => 'apps', :action => 'show', :id => 1 } to /apps/1" do
      route_for(:controller => "apps", :action => "show", :id => 1).should == "/apps/1"
    end
  
    it "should map { :controller => 'apps', :action => 'edit', :id => 1 } to /apps/1/edit" do
      route_for(:controller => "apps", :action => "edit", :id => 1).should == "/apps/1/edit"
    end
  
    it "should map { :controller => 'apps', :action => 'update', :id => 1} to /apps/1" do
      route_for(:controller => "apps", :action => "update", :id => 1).should == "/apps/1"
    end
  
  end

  describe "route recognition" do

    it "should generate params { :controller => 'apps', action => 'index' } from GET /apps" do
      params_from(:get, "/apps").should == {:controller => "apps", :action => "index"}
    end
  
    it "should generate params { :controller => 'apps', action => 'new' } from GET /apps/new" do
      params_from(:get, "/apps/new").should == {:controller => "apps", :action => "new"}
    end
  
    it "should generate params { :controller => 'apps', action => 'create' } from POST /apps" do
      params_from(:post, "/apps").should == {:controller => "apps", :action => "create"}
    end
  
    it "should generate params { :controller => 'apps', action => 'show', id => '1' } from GET /apps/1" do
      params_from(:get, "/apps/1").should == {:controller => "apps", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'apps', action => 'edit', id => '1' } from GET /apps/1;edit" do
      params_from(:get, "/apps/1/edit").should == {:controller => "apps", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'apps', action => 'update', id => '1' } from PUT /apps/1" do
      params_from(:put, "/apps/1").should == {:controller => "apps", :action => "update", :id => "1"}
    end
  
  end
end
