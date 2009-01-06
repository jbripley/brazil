require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/flash/notice" do
  before(:each) do
    flash[:notice] = 'Test Notice'
    render 'flash/notice'
  end
  
  it "should display the flash notice" do
    response.should have_text(/Test\ Notice/)
  end
end
