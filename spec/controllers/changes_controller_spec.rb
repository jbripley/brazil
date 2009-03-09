require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChangesController do
  before(:each) do
    @app = mock_model(App, :to_param => "2")
    App.stub!(:find).with("2").and_return(@app)

    @activity = mock_model(Activity, :to_param => "2")
    @activity.stub!(:app).and_return(@app)

    @activities = mock(Array)
    @activities.stub!(:find).and_return(@activity)
    @app.stub!(:activities).and_return(@activities)

    change = mock_model(Change)
    @changes = mock(Array)
    @changes.stub!(:find).and_return(change)
    @activity.stub!(:changes).and_return(@changes)

    Activity.stub!(:find).with("2").and_return(@activity)
  end

  describe "handling GET /changes" do  
    def do_get
      get :index, :app_id => '2', :activity_id => '2', :format => 'xml'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index as xml" do
      @changes.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end

    it "should find all changes" do
      @activity.should_receive(:changes).and_return(@changes)
      do_get
    end

    it "should assign the found changes for the view" do
      do_get
      assigns[:activity].should == @activity
      assigns[:changes].should == @changes
    end
  end

  describe "handling GET /changes/1" do

    before(:each) do
      @change = mock_model(Change)
      @changes.stub!(:find).and_return(@change)
    end

    def do_get
      get :show, :id => "1", :app_id => '2', :activity_id => '2'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should find the change requested" do
      @changes.should_receive(:find).with("1").and_return(@change)
      do_get
    end

    it "should assign the found change for the view" do
      do_get
      assigns[:change].should equal(@change)
    end
  end

  describe "handling GET /changes/new" do

    before(:each) do
      @change = mock_model(Change)
      @changes.stub!(:build).and_return(@change)
    end

    def do_get
      get :new, :app_id => '2', :activity_id => '2'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render new template" do
      do_get
      response.should render_template('new')
    end

    it "should create an new change" do
      @changes.should_receive(:build).and_return(@change)
      do_get
    end

    it "should not save the new change" do
      @change.should_not_receive(:save)
      do_get
    end

    it "should assign the new change for the view" do
      do_get
      assigns[:change].should equal(@change)
    end
  end

  describe "handling GET /changes/1/edit" do

    before(:each) do
      @change = mock_model(Change)
      Change.stub!(:find).and_return(@change)

      @changes.stub!(:find).and_return(@change)
    end

    def do_get
      get :edit, :id => "1", :app_id => '2', :activity_id => '2'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

    it "should find the change requested" do
      @changes.should_receive(:find).and_return(@change)
      do_get
    end

    it "should assign the found Changes for the view" do
      do_get
      assigns[:change].should equal(@change)
    end
  end

  describe "handling POST /changes" do

    before(:each) do
      Activity.stub!(:find).with('2').and_return(@activity)

      @change = mock_model(Change, :to_param => "1")
      @change.stub!(:sql).and_return('')

      @changes.stub!(:build).and_return(@change)
    end

    describe "with successful save" do

      def do_post
        @change.stub!(:valid?).and_return(true)
        @change.stub!(:use_sql).and_return(true)

        @change.should_receive(:save).and_return(true)
        @change.should_receive(:state=).with('saved')
        post :create, :change => {}, :app_id => '2', :activity_id => '2'
      end

      it "should create a new change" do
        @changes.should_receive(:build).with({}).and_return(@change)
        do_post
      end

      it "should redirect to the new change" do
        do_post
        response.should redirect_to(app_activity_url('2', '2'))
      end

    end

    describe "with failed save" do

      def do_post
        @change.stub!(:valid?).and_return(false)
        @change.stub!(:use_sql).and_return(false)

        @change.should_receive(:state=).with('saved')
        post :create, :change => {}, :app_id => '2', :activity_id => '2'
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /changes/1" do

    before(:each) do
      Activity.stub!(:find).and_return(@activity)

      @change = mock_model(Change, :to_param => "1")
      @change.stub!(:sql).and_return('')
      @change.stub!(:activity).and_return(@activity)

      @change.should_receive(:attributes=).with(nil)
      @change.should_receive(:state=).with('saved')

      @changes.stub!(:find).with("1").and_return(@change)
    end

    describe "with successful update" do

      def do_put
        @change.stub!(:valid?).and_return(true)
        @change.stub!(:use_sql).and_return(true)

        @change.should_receive(:save).and_return(true)
        put :update, :id => "1", :app_id => '2', :activity_id => '2'
      end

      it "should find the change requested" do
        @changes.should_receive(:find).with("1").and_return(@change)
        do_put
      end

      it "should update the found change" do
        do_put
        assigns(:change).should equal(@change)
      end

      it "should assign the found change for the view" do
        do_put
        assigns(:change).should equal(@change)
      end

      it "should redirect to the activity containing the change" do
        do_put
        response.should redirect_to(app_activity_url("2", "2"))
      end

    end

    describe "with failed update" do

      def do_put
        @change.should_receive(:valid?).and_return(false)
        put :update, :id => "1", :app_id => '2', :activity_id => '2'
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

end
