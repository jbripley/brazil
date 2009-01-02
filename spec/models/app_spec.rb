require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe App, "with fixtures loaded" do
  fixtures :apps, :activities
  
  before(:each) do
    @valid_attributes = {
      :id => 1,
      :name => 'App'
    }
    @app = App.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    App.create!(@valid_attributes)
  end
    
  it "should not be possible to create without a name" do
    @app.name = nil
    @app.should_not be_valid
  end
  
  it "should name and to_s be equal" do
    @app.name.should eql(@app.to_s)
  end
  
  it "should sort activities with updated_at DESC" do
    apps(:app_1).activities.first.should eql(Activity.find_by_app_id(apps(:app_1).id, :order => 'updated_at DESC'))
  end
end
