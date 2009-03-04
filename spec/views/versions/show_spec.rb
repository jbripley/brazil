require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/versions/show.html.erb" do
  include VersionsHelper
  fixtures :db_instances
  fixtures :apps, :activities, :db_instances

  before do
    @app = apps(:app_1)

    @activity = activities(:app_1_dev)
    @activity.stub!(:app).and_return(@app)

    assigns[:activity] = @activity

    @version = mock_model(Version)
    @version.should_receive(:state).at_least(:once).and_return("created")
    @version.should_receive(:schema).and_return("brazil_test")
    @version.should_receive(:schema_version).and_return("2_23_7")
    @version.should_receive(:created?).at_least(:once).and_return(true)
    @version.should_receive(:tested?).at_least(:once).and_return(false)
    @version.stub!(:updated_at).and_return(Time.zone.now)
    @version.stub!(:preparation).and_return("DoFooThenBar")
    @version.stub!(:update_sql).and_return("CreateTableFoo")
    @version.stub!(:rollback_sql).and_return("DropTableFoo")

    @version.stub!(:db_instances).and_return([db_instances(:test_1)])
    @version.stub!(:db_instance_test).and_return(db_instances(:test_1))
    @version.stub!(:activity).and_return(@activity)

    assigns[:version] = @version

    template.should_receive(:create_update_sql).with(@version).and_return('VersionedUpdateSQL')
    template.should_receive(:create_rollback_sql).with(@version).and_return('VersionedRollbackSQL')
  end

  it "should render attributes in <p>" do
    render "/versions/show.html.erb"
    response.should have_text(/created/)
    response.should have_text(/brazil_test/)
    response.should have_text(/2_23_7/)
    response.should have_text(/VersionedUpdateSQL/)
    response.should have_text(/VersionedRollbackSQL/)
  end
end

