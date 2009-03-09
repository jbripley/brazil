require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChangeSuggestionsController do
  before(:each) do
    @app = mock_model(App, :to_param => "1")
    App.stub!(:find).with("1").and_return(@app)

    @activity = mock_model(Activity, :to_param => "2")
    @activity.stub!(:app).and_return(@app)

    @activities = mock(Array)
    @activities.stub!(:find).and_return(@activity)
    @app.stub!(:activities).and_return(@activities)    
  end

  describe "handling GET /change_suggetions/new" do

    before(:each) do
      @change = mock_model(Change)
      @changes.stub!(:build).and_return(@change)

      @changes = mock(Array)
      @changes.stub!(:build).and_return(@change)
      @activity.stub!(:changes).and_return(@changes)

      Activity.stub!(:find).with("2").and_return(@activity)
    end

    def do_get
      get :new, :app_id => '1', :activity_id => '2'
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

  describe "handling POST /change_suggestions" do

    before(:each) do
      @change = mock_model(Change, :to_param => "1")
      @change.stub!(:sql).and_return('')
      @change.should_receive(:state=).with(Change::STATE_SUGGESTED)

      @changes = mock(Array)
      @changes.stub!(:build).and_return(@change)
      
      @activity.stub!(:changes).and_return(@changes)

      Activity.stub!(:find).with("2").and_return(@activity)
    end

    describe "with successful save" do

      def do_post
        @change.stub!(:valid?).and_return(true)
        @change.stub!(:use_sql).and_return(true)

        @change.should_receive(:save).and_return(true)
        post :create, :change => {}, :app_id => '1', :activity_id => '2'
      end

      it "should create a new change" do
        @changes.stub!(:build).should_receive(:build).with({}).and_return(@change)
        do_post
      end

      it "should redirect to the new change" do
        do_post
        response.should redirect_to(app_activity_url('1', '2'))
      end

    end

    describe "with failed save" do

      def do_post
        @change.stub!(:save).and_return(false)
        post :create, :change => {}, :app_id => '1', :activity_id => '2'
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

end
