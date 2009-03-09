require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VersionsController do
  before(:each) do
    @app = mock_model(App, :to_param => "3")
    App.stub!(:find).with("3").and_return(@app)

    @activity = mock_model(Activity, :to_param => "3")
    @activity.stub!(:app).and_return(@app)

    @activities = mock(Array)
    @activities.stub!(:find).and_return(@activity)
    @app.stub!(:activities).and_return(@activities)
  end

  describe "handling GET /versions" do

    before(:each) do
      Activity.stub!(:find).with('3').and_return(@activity)

      @version = mock_model(Version)

      @versions = mock(Array)
      @versions.stub!(:all).and_return([@version])
      @versions.stub!(:build).and_return(mock_model(Activity))
      @activity.stub!(:versions).and_return(@versions)
    end

    def do_get
      get :index, :app_id => '3', :activity_id => '3'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

    it "should find all versions" do
      @versions.should_receive(:all).and_return([@version])
      do_get
    end

    it "should assign the found versions for the view" do
      do_get
      assigns[:versions].should == [@version]
    end
  end

  describe "handling GET /versions/1" do

    before(:each) do
      Activity.stub!(:find).with('3').and_return(@activity)

      @version = mock_model(Version)

      @versions = mock(Array)
      @versions.stub!(:find).and_return(@version)
      @activity.stub!(:versions).and_return(@versions)
    end

    def do_get
      get :show, :id => "1", :app_id => '3', :activity_id => '3'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should find the version requested" do
      @versions.should_receive(:find).and_return(@version)
      do_get
    end

    it "should assign the found version for the view" do
      do_get
      assigns[:version].should equal(@version)
    end
  end

  describe "handling GET /versions/new" do

    before(:each) do
      Activity.stub!(:find).with('3').and_return(@activity)

      @version = mock_model(Version)
      @version.should_receive(:update_sql=)

      @versions = mock(Array)
      @versions.stub!(:build).and_return(@version)
      @activity.stub!(:versions).and_return(@versions)
    end

    def do_get
      get :new, :app_id => '3', :activity_id => '3'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render new template" do
      do_get
      response.should render_template('new')
    end

    it "should create an new version" do
      @versions.should_receive(:build).and_return(@version)
      do_get
    end

    it "should not save the new version" do
      @version.should_not_receive(:save)
      do_get
    end

    it "should assign the new version for the view" do
      do_get
      assigns[:version].should equal(@version)
    end
  end

  describe "handling GET /versions/1/edit" do
    before(:each) do
      Activity.stub!(:find).with('3').and_return(@activity)

      @version = mock_model(Version)

      @versions = mock(Array)
      @activity.stub!(:versions).and_return(@versions)
      @versions.stub!(:find).and_return(@version)
    end

    def do_get
      get :edit, :id => "1", :app_id => '3', :activity_id => '3'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

    it "should find the version requested" do
      @versions.should_receive(:find).and_return(@version)
      do_get
    end

    it "should assign the found Versions for the view" do
      do_get
      assigns[:version].should equal(@version)
    end
  end

  describe "handling POST /versions" do
    before(:each) do
      Activity.stub!(:find).with('3').and_return(@activity)

      @version = mock_model(Version, :to_param => "1")
      @version.should_receive(:init_schema_version)
      @version.errors.should_receive(:empty?).and_return(true)

      @versions = mock(Array)
      @activity.stub!(:versions).and_return(@versions)
      @versions.stub!(:build).and_return(@version)   
    end

    describe "with successful save" do

      def do_post
        @version.should_receive(:save).and_return(true)
        post :create, :version => {}, :app_id => '3', :activity_id => '3'
      end

      it "should create a new version" do
        @versions.should_receive(:build).with({}).and_return(@version)
        do_post
      end

      it "should redirect to the new version" do
        do_post
        response.should redirect_to(app_activity_version_url('3', '3', "1"))
      end

    end

    describe "with failed save" do

      def do_post
        @version.should_receive(:save).and_return(false)
        post :create, :version => {}, :app_id => '3', :activity_id => '3'
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /versions/1" do
    before(:each) do
      @schema_version_major = '1'
      @schema_version_minor = '2'
      @schema_version_patch = '3'

      Activity.stub!(:find).and_return(@activity)

      @version = mock_model(Version, :to_param => "1")
      @version.should_receive(:update_schema_version).with([@schema_version_major, @schema_version_minor, @schema_version_patch].join('_'), nil, nil)
      @version.should_receive(:attributes=)
      @version.errors.should_receive(:empty?).and_return(true)

      @versions = mock(Array)
      @activity.stub!(:versions).and_return(@versions)
      @versions.stub!(:find).and_return(@version)
    end

    describe "with successful update" do

      def do_put
        @version.should_receive(:save).and_return(true)
        put :update, :id => "1", :app_id => '3', :activity_id => '3', :schema_version_major => @schema_version_major, :schema_version_minor => @schema_version_minor, :schema_version_patch => @schema_version_patch
      end

      it "should find the version requested" do
        @versions.should_receive(:find).with("1").and_return(@version)
        do_put
      end

      it "should update the found version" do
        do_put
        assigns(:version).should equal(@version)
      end

      it "should assign the found version for the view" do
        do_put
        assigns(:version).should equal(@version)
      end

      it "should redirect to the version" do
        do_put
        response.should redirect_to(app_activity_version_url('3', '3', "1"))
      end

    end

    describe "with failed update" do

      def do_put
        @version.should_receive(:save).and_return(false)
        put :update, :id => "1", :app_id => '3', :activity_id => '3', :schema_version_major => @schema_version_major, :schema_version_minor => @schema_version_minor, :schema_version_patch => @schema_version_patch
      end

      it "should re-render 'show'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

end
