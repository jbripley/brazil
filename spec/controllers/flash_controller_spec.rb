require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlashController do

  #Delete these examples and add some real ones
  it "should use FlashController" do
    controller.should be_an_instance_of(FlashController)
  end


  describe "GET 'notice'" do
    it "should be successful" do
      get 'notice'
      response.should be_success
    end
  end
end
