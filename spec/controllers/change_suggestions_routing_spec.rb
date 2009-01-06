require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChangeSuggestionsController do
  describe "route generation" do

    it "should map { :controller => 'change_suggestions', :action => 'new' } to /apps/1/activities/2/change_suggestions/new" do
      route_for(:controller => "change_suggestions", :action => "new", :app_id => '1', :activity_id => '2').should == "/apps/1/activities/2/change_suggestions/new"
    end

  end

  describe "route recognition" do

    it "should generate params { :controller => 'change_suggestions', action => 'new', :app_id => '1', :activity_id => '2' } from GET /apps/1/activities/2/change_suggestions/new" do
      params_from(:get, "/apps/1/activities/2/change_suggestions/new").should == {:controller => "change_suggestions", :action => "new", :app_id => '1', :activity_id => '2'}
    end

    it "should generate params { :controller => 'change_suggestions', action => 'create', :app_id => '1', :activity_id => '2' } from POST /apps/1/activities/2/change_suggestions" do
      params_from(:post, "/apps/1/activities/2/change_suggestions").should == {:controller => "change_suggestions", :action => "create", :app_id => '1', :activity_id => '2'}
    end

  end
end
