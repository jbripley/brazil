require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DbInstancesController do
  describe "route generation" do

    it "should map { :controller => 'db_instances', :action => 'index' } to /db_instances" do
      route_for(:controller => "db_instances", :action => "index").should == "/db_instances"
    end
  
    it "should map { :controller => 'db_instances', :action => 'new' } to /db_instances/new" do
      route_for(:controller => "db_instances", :action => "new").should == "/db_instances/new"
    end
  
    it "should map { :controller => 'db_instances', :action => 'show', :id => 1 } to /db_instances/1" do
      route_for(:controller => "db_instances", :action => "show", :id => 1).should == "/db_instances/1"
    end
  
    it "should map { :controller => 'db_instances', :action => 'edit', :id => 1 } to /db_instances/1/edit" do
      route_for(:controller => "db_instances", :action => "edit", :id => 1).should == "/db_instances/1/edit"
    end
  
    it "should map { :controller => 'db_instances', :action => 'update', :id => 1} to /db_instances/1" do
      route_for(:controller => "db_instances", :action => "update", :id => 1).should == "/db_instances/1"
    end
  
    it "should map { :controller => 'db_instances', :action => 'destroy', :id => 1} to /db_instances/1" do
      route_for(:controller => "db_instances", :action => "destroy", :id => 1).should == "/db_instances/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'db_instances', action => 'index' } from GET /db_instances" do
      params_from(:get, "/db_instances").should == {:controller => "db_instances", :action => "index"}
    end
  
    it "should generate params { :controller => 'db_instances', action => 'new' } from GET /db_instances/new" do
      params_from(:get, "/db_instances/new").should == {:controller => "db_instances", :action => "new"}
    end
  
    it "should generate params { :controller => 'db_instances', action => 'create' } from POST /db_instances" do
      params_from(:post, "/db_instances").should == {:controller => "db_instances", :action => "create"}
    end
  
    it "should generate params { :controller => 'db_instances', action => 'show', id => '1' } from GET /db_instances/1" do
      params_from(:get, "/db_instances/1").should == {:controller => "db_instances", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'db_instances', action => 'edit', id => '1' } from GET /db_instances/1;edit" do
      params_from(:get, "/db_instances/1/edit").should == {:controller => "db_instances", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'db_instances', action => 'update', id => '1' } from PUT /db_instances/1" do
      params_from(:put, "/db_instances/1").should == {:controller => "db_instances", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'db_instances', action => 'destroy', id => '1' } from DELETE /db_instances/1" do
      params_from(:delete, "/db_instances/1").should == {:controller => "db_instances", :action => "destroy", :id => "1"}
    end
  end
end
