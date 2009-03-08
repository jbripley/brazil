require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VersionsController do
  describe "handling GET /versions" do

    before(:each) do
      @version = mock_model(Version)
      Version.stub!(:find).and_return([@version])
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
      Version.should_receive(:find).with(:all, {:limit=>nil, :joins=>nil, :select=>nil, :group=>nil, :readonly=>nil, :offset=>nil, :conditions=>"\"versions\".activity_id = 3", :include=>nil}).and_return([@version])
      do_get
    end

    it "should assign the found versions for the view" do
      do_get
      assigns[:versions].should == [@version]
    end
  end

  describe "handling GET /versions/1" do

    before(:each) do
      @version = mock_model(Version)
      Version.stub!(:find).and_return(@version)
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
      Version.should_receive(:find).with("1", {:joins=>nil, :readonly=>nil, :limit=>nil, :conditions=>"\"versions\".activity_id = 3", :select=>nil, :group=>nil, :offset=>nil, :include=>nil}).and_return(@version)
      do_get
    end

    it "should assign the found version for the view" do
      do_get
      assigns[:version].should equal(@version)
    end
  end

  describe "handling GET /versions/new" do

    before(:each) do
      @version = mock_model(Version)
      @version.should_receive(:[]=).with('activity_id', 3)
      @version.should_receive(:update_sql=)

      Version.stub!(:new).and_return(@version)
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
      Version.should_receive(:new).and_return(@version)
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
      @version = mock_model(Version)
      Version.stub!(:find).and_return(@version)
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
      Version.should_receive(:find).and_return(@version)
      do_get
    end

    it "should assign the found Versions for the view" do
      do_get
      assigns[:version].should equal(@version)
    end
  end

  describe "handling POST /versions" do
    fixtures :apps, :activities

    before(:each) do
      @app = apps(:app_3)

      @activity = activities(:app_1_deployed)
      @activity.stub!(:app).and_return(@app)

      Activity.stub!(:find).with('3').and_return(@activity)

      @version = mock_model(Version, :to_param => "1")
      @version.should_receive(:activity_id=).with('3')
      @version.should_receive(:init_schema_version)
      @version.errors.should_receive(:empty?).and_return(true)

      Version.stub!(:new).and_return(@version)
    end

    describe "with successful save" do

      def do_post
        @version.should_receive(:save).and_return(true)
        post :create, :version => {}, :app_id => '3', :activity_id => '3'
      end

      it "should create a new version" do
        Version.should_receive(:new).with({}).and_return(@version)
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
    fixtures :apps, :activities

    before(:each) do
      @schema_version_major = '1'
      @schema_version_minor = '2'
      @schema_version_patch = '3'

      @app = apps(:app_3)
      App.stub!(:find).and_return(@app)

      @activity = activities(:app_1_deployed)

      @activities = mock(Array)
      @activities.stub!(:find).and_return(@activity)
      @app.stub!(:activities).and_return(@activities)

      @version = mock_model(Version, :to_param => "1")
      @version.should_receive(:update_schema_version).with([@schema_version_major, @schema_version_minor, @schema_version_patch].join('_'), nil, nil)

      Version.stub!(:find).with('1').and_return(@version)
      @version.stub!(:find).with('1').and_return(@version)
      @activity.stub!(:versions).and_return(@version)

      versions = mock(Object)
      versions.stub!(:build).and_return(@version)
      @activites.stub!(:versions).and_return(versions)

      db_instance = mock_model(DbInstance)
      db_instance.should_receive(:find_next_schema_version).and_return("1_2_2")
      DbInstance.stub!(:find_all_by_id).and_return([db_instance]) 
    end

    describe "with successful update" do

      def do_put
        @version.should_receive(:save).and_return(true)
        put :update, :id => "1", :app_id => '3', :activity_id => '3', :schema_version_major => @schema_version_major, :schema_version_minor => @schema_version_minor, :schema_version_patch => @schema_version_patch
      end

      it "should find the version requested" do
        @version.should_receive(:find).with("1").and_return(@version)
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
