require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlashController do
  describe "route generation" do

    it "should map { :controller => 'flash', :action => 'notice' } to /flash/notice" do
      route_for(:controller => 'flash', :action => 'notice').should == "/flash/notice"
    end
  
  end

  describe "route recognition" do

    it "should generate params { :controller => 'flash', :action => 'notice' } from GET /flash/notice" do
      params_from(:get, "/flash/notice").should == {:controller => 'flash', :action => 'notice'}
    end
  
  end
end
