require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/versions/index.html.erb" do
  include VersionsHelper
  fixtures :apps, :activities, :db_instances

  before do
    @app = apps(:app_1)

    @activity = activities(:app_1_dev)
    @activity.stub!(:app).and_return(@app)

    assigns[:activity] = @activity
    
    version_98 = mock_model(Version)
    version_98.should_receive(:state).at_least(:once).and_return("created")
    version_98.should_receive(:schema).and_return("brazil_test")
    version_98.should_receive(:schema_version).and_return("2_23")
    version_98.should_receive(:deploy_note).twice.and_return("DeployNote")  
    version_98.stub!(:updated_at).and_return(Time.zone.now)
    version_98.stub!(:db_instances).and_return([db_instances(:test_1)])
    version_98.stub!(:activity).and_return(@activity)

    version_99 = mock_model(Version)
    version_99.should_receive(:state).at_least(:once).and_return("tested")
    version_99.should_receive(:schema).and_return("brazil_test")
    version_99.should_receive(:schema_version).and_return("3_1")  
    version_99.should_receive(:deploy_note).twice.and_return("DeployNote")
    version_99.stub!(:updated_at).and_return(Time.zone.now)
    version_99.stub!(:db_instances).and_return([db_instances(:test_2)])
    version_99.stub!(:activity).and_return(@activity)

    assigns[:versions] = [version_98, version_99] 
  end

  it "should render list of versions" do
    render "/versions/index.html.erb"

    # state
    response.should have_text(/created/)
    response.should have_text(/tested/)

    # schema
    response.should have_text(/brazil_test/)

    # version
    response.should have_text(/2_23/)
    response.should have_text(/3_1/)

    # deploynote
    response.should have_text(/DeployNote/)
  end
end

