require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivitiesController do
  fixtures :apps

  describe "handling GET /apps/:app_id/activities" do

    before(:each) do
      @activity = mock_model(Activity)
      
      @activities = mock(Array)
      @activities.stub!(:find).with(:all).and_return([@activity])
      
      @app = mock_model(App)
      @app.stub!(:activities).and_return(@activities)
      
      App.stub!(:find).with("1").and_return(@app)
    end
  
    def do_get
      get :index, :app_id => '1', :format => 'html'
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all activities" do
      @app.should_receive(:activities).and_return(@activities)
      do_get
    end
  
    it "should assign the found activities for the view" do
      do_get
      assigns[:app].should == @app
      assigns[:activities].should == [@activity]
    end
  end

  describe "handling GET /activities/1" do

    before(:each) do
      @activity = mock_model(Activity)
      Activity.stub!(:find).and_return(@activity)
    end
  
    def do_get
      get :show, :id => "1", :app_id => 1, :format => 'html'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the activity requested" do
      Activity.should_receive(:find).with("1", {:conditions => "\"activities\".app_id = 1", :select => nil, :group => nil, :readonly => nil, :offset => nil, :joins => nil, :order => "updated_at DESC", :include => nil, :limit => nil}).and_return(@activity)
      do_get
    end
  
    it "should assign the found activity for the view" do
      do_get
      assigns[:activity].should equal(@activity)
    end
  end

  describe "handling GET /activities/new" do

    before(:each) do
      @activity = mock_model(Activity)
      @activity.should_receive(:[]=).with('app_id', 1)
      
      Activity.stub!(:new).and_return(@activity)
    end
  
    def do_get
      get :new, :app_id => 1, :format => 'html'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new activity" do
      Activity.should_receive(:new).and_return(@activity)
      do_get
    end
  
    it "should not save the new activity" do
      @activity.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new activity for the view" do
      do_get
      assigns[:activity].should equal(@activity)
    end
  end

  describe "handling GET /activities/1/edit" do

    before(:each) do
      @activity = mock_model(Activity)
      Activity.stub!(:find).and_return(@activity)
    end
  
    def do_get
      get :edit, :id => "1", :app_id => 1, :format => 'html'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the activity requested" do
      Activity.should_receive(:find).and_return(@activity)
      do_get
    end
  
    it "should assign the found Activities for the view" do
      do_get
      assigns[:activity].should equal(@activity)
    end
  end

  describe "handling POST /activities" do

    before(:each) do
      @activity = mock_model(Activity, :to_param => "1")
      @activity.should_receive(:[]=).with('app_id', 1)
      
      Activity.stub!(:new).and_return(@activity)
    end
    
    describe "with successful save" do
  
      def do_post
        @activity.should_receive(:save).and_return(true)
        post :create, :activity => {}, :app_id => 1, :format => 'html'
      end
  
      it "should create a new activity" do
        Activity.should_receive(:new).with({}).and_return(@activity)
        do_post
      end

      it "should redirect to the new activity" do
        do_post
        response.should redirect_to(app_activity_url('1', "1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @activity.should_receive(:save).and_return(false)
        post :create, :activity => {}, :app_id => 1, :format => 'html'
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /activities/1" do

    before(:each) do
      @activity = mock_model(Activity, :to_param => "1")
      Activity.stub!(:find).and_return(@activity)
    end
    
    describe "with successful update" do

      def do_put
        @activity.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1", :app_id => 1, :format => 'html'
      end

      it "should find the activity requested" do
        Activity.should_receive(:find).with("1", {:joins => nil, :limit => nil, :select => nil, :group => nil, :offset => nil, :order => "updated_at DESC", :conditions => "\"activities\".app_id = 1", :readonly => nil, :include => nil}).and_return(@activity)
        do_put
      end

      it "should update the found activity" do
        do_put
        assigns(:activity).should equal(@activity)
      end

      it "should assign the found activity for the view" do
        do_put
        assigns(:activity).should equal(@activity)
      end

      it "should redirect to the activity" do
        do_put
        response.should redirect_to(app_activity_url('1', "1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @activity.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1", :app_id => 1, :format => 'html'
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

end
