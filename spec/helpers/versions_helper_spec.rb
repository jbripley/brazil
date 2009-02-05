require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VersionsHelper do
  describe "when calling sql_escape" do
    it "should return an escaped string if a string is sent in" do
      string = 'foo'
      escaped_string = "'foo'"
      helper.sql_escape(string).should eql(escaped_string)
    end
    
    it "should return a number in a string if a number is sent in" do
      number = 23
      escaped_string = "23"
      helper.sql_escape(number).should eql(escaped_string)
    end
    
    it "should return NULL if nil is sent in" do
      escaped_string = "NULL"
      helper.sql_escape(nil).should eql(escaped_string)
    end
  end
  
end
