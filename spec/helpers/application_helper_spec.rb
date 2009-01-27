require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do

  it "should call generate_title and return a title" do
    title = 'Home > Foo > Bar'
    crumbs = [[], ['Home', nil], ['Foo', nil], ['Bar', nil]]

    helper.generate_title(crumbs).should eql(title)
  end

  it "should call brazil_release and return a version" do
    release_version = '4.7.11'
    release_name = 'FooBar'

    AppConfig.stub!(:release_version).and_return(release_version)
    AppConfig.stub!(:release_name).and_return(release_name)

    helper.brazil_release.should eql("#{release_version} (#{release_name})")
  end

  describe "when calling activity_link_to" do
    before(:each) do
      app = mock_model(App, :to_param => "33")
      @activity = mock_model(Activity, :to_param => "42")
      @activity.stub!(:app).and_return(app)
    end

    it "should get an activity in state development and return a link to the activity" do
      @activity.stub!(:state).and_return(Activity::STATE_DEVELOPMENT)

      helper.activity_link_to(@activity).should eql(link_to(@activity, app_activity_path(@activity.app, @activity)))
    end

    it "should get an activity in state versioned and return a link to the activities version" do
      @activity.stub!(:state).and_return(Activity::STATE_VERSIONED)

      helper.activity_link_to(@activity).should eql(link_to(@activity, app_activity_versions_path(@activity.app, @activity)))
    end

    it "should get an activity in state deployed and return a link to the activities version" do
      @activity.stub!(:state).and_return(Activity::STATE_DEPLOYED)

      helper.activity_link_to(@activity).should eql(link_to(@activity, app_activity_versions_path(@activity.app, @activity)))
    end

    it "should get an activity in an unknown state" do
      @activity.stub!(:state).and_return('UNKNOWN')

      logger = mock(Logger, :null_object => true)
      logger.should_receive(:warn)
      helper.should_receive(:logger).and_return(logger)

      helper.activity_link_to(@activity)
    end
  end

  describe "when calling atom_feed_tag" do
    before(:each) do
      @controller = mock(ActionController::Base)
    end

    it "should lookup url for Apps feed" do
      @controller.stub!(:controller_name).and_return('apps')
      @controller.stub!(:action_name).and_return('index')
      helper.stub!(:controller).and_return(@controller)

      params = {:id => 1}
      helper.stub!(:params).and_return(params)
      helper.should_receive(:formatted_apps_path).with({:format=>"atom", :id => params[:id]})

      helper.atom_feed_tag
    end

    it "should lookup url for App Activities feed" do
      @controller.stub!(:controller_name).and_return('activities')
      @controller.stub!(:action_name).and_return('index')
      helper.stub!(:controller).and_return(@controller)

      params = {:app_id => 1}
      helper.stub!(:params).and_return(params)
      helper.should_receive(:formatted_app_activities_path).with({:format=>"atom", :app_id => params[:app_id]})

      helper.atom_feed_tag
    end

    it "should lookup url for App Activity feed" do
      @controller.stub!(:controller_name).and_return('activities')
      @controller.stub!(:action_name).and_return('show')
      helper.stub!(:controller).and_return(@controller)

      params = {:app_id => 1, :id => 2}
      helper.stub!(:params).and_return(params)
      helper.should_receive(:formatted_app_activity_path).with({:format=>"atom", :app_id => params[:app_id], :id => params[:id]})

      helper.atom_feed_tag
    end

    it "should lookup url for App Activity Versions feed" do
      @controller.stub!(:controller_name).and_return('versions')
      @controller.stub!(:action_name).and_return('index')
      helper.stub!(:controller).and_return(@controller)

      params = {:id => 2}
      helper.stub!(:params).and_return(params)
      helper.should_receive(:formatted_app_activity_versions_path).with({:format=>"atom", :id => params[:id]})

      helper.atom_feed_tag
    end

    it "should return nil when it is an unknown controller action" do
      @controller.stub!(:controller_name).and_return('foo')
      @controller.stub!(:action_name).and_return('bar')
      helper.stub!(:controller).and_return(@controller)

      helper.atom_feed_tag.should be_nil
    end
  end

  it "should call truncate_words and the right number of words" do
    text = 'this text is made up of eight words'
    helper.truncate_words(text, 8).should eql(text)
  end

  it "should get first and last name from an email of the form firstname.lastname@foo.com" do
    email = 'firstname.lastname@foo.com'
    name = 'Firstname Lastname'

    helper.email_to_realname(email).should eql(name)
  end

end
