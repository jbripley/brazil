require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AppsController do
  describe "handling GET /apps" do

    before(:each) do
      @app = mock_model(App)
      App.stub!(:find).and_return([@app])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all apps" do
      App.should_receive(:find).with(:all).and_return([@app])
      do_get
    end
  
    it "should assign the found apps for the view" do
      do_get
      assigns[:apps].should == [@app]
    end
  end

  describe "handling GET /apps/1" do

    before(:each) do
      @app = mock_model(App)
      App.stub!(:find).and_return(@app)
    end
  
    def do_get
      get :show, :id => "1", :format => 'html'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the app requested" do
      App.should_receive(:find).with("1").and_return(@app)
      do_get
    end
  
    it "should assign the found app for the view" do
      do_get
      assigns[:app].should equal(@app)
    end
  end

  describe "handling GET /apps/new" do

    before(:each) do
      @app = mock_model(App)
      App.stub!(:new).and_return(@app)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new app" do
      App.should_receive(:new).and_return(@app)
      do_get
    end
  
    it "should not save the new app" do
      @app.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new app for the view" do
      do_get
      assigns[:app].should equal(@app)
    end
  end

  describe "handling GET /apps/1/edit" do

    before(:each) do
      @app = mock_model(App)
      App.stub!(:find).and_return(@app)
    end
  
    def do_get
      get :edit, :id => "1", :format => 'html'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the app requested" do
      App.should_receive(:find).and_return(@app)
      do_get
    end
  
    it "should assign the found Apps for the view" do
      do_get
      assigns[:app].should equal(@app)
    end
  end

  describe "handling POST /apps" do

    before(:each) do
      @app = mock_model(App, :to_param => "1")
      App.stub!(:new).and_return(@app)
    end
    
    describe "with successful save" do
  
      def do_post
        @app.should_receive(:save).and_return(true)
        post :create, :app => {'name' => 'Foo App'}, :format => 'html'
      end
  
      it "should create a new app" do
        App.should_receive(:new).with({'name' => 'Foo App'}).and_return(@app)
        do_post
      end

      it "should redirect to the app activities view" do
        do_post
        response.should redirect_to(app_activities_path("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @app.should_receive(:save).and_return(false)
        post :create, :app => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /apps/1" do

    before(:each) do
      @app = mock_model(App, :to_param => "1")
      App.stub!(:find).and_return(@app)
    end
    
    describe "with successful update" do

      def do_put
        @app.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1", :format => 'html'
      end

      it "should find the app requested" do
        App.should_receive(:find).with("1").and_return(@app)
        do_put
      end

      it "should update the found app" do
        do_put
        assigns(:app).should equal(@app)
      end

      it "should assign the found app for the view" do
        do_put
        assigns(:app).should equal(@app)
      end

      it "should redirect to the app" do
        do_put
        response.should redirect_to(app_activities_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @app.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

end
