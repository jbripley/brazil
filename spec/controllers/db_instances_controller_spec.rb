require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DbInstancesController do
  describe "handling GET /db_instances" do

    before(:each) do
      @db_instance = mock_model(DbInstance)
      DbInstance.stub!(:find).and_return([@db_instance])
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
  
    it "should find all db_instances" do
      DbInstance.should_receive(:find).with(:all).and_return([@db_instance])
      do_get
    end
  
    it "should assign the found db_instances for the view" do
      do_get
      assigns[:db_instances].should == [@db_instance]
    end
  end

  describe "handling GET /db_instances/1" do

    before(:each) do
      @db_instance = mock_model(DbInstance)
      DbInstance.stub!(:find).and_return(@db_instance)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the db_instance requested" do
      DbInstance.should_receive(:find).with("1").and_return(@db_instance)
      do_get
    end
  
    it "should assign the found db_instance for the view" do
      do_get
      assigns[:db_instance].should equal(@db_instance)
    end
  end

  describe "handling GET /db_instances/new" do

    before(:each) do
      @db_instance = mock_model(DbInstance)
      DbInstance.stub!(:new).and_return(@db_instance)
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
  
    it "should create an new db_instance" do
      DbInstance.should_receive(:new).and_return(@db_instance)
      do_get
    end
  
    it "should not save the new db_instance" do
      @db_instance.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new db_instance for the view" do
      do_get
      assigns[:db_instance].should equal(@db_instance)
    end
  end

  describe "handling GET /db_instances/1/edit" do

    before(:each) do
      @db_instance = mock_model(DbInstance)
      DbInstance.stub!(:find).and_return(@db_instance)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the db_instance requested" do
      DbInstance.should_receive(:find).and_return(@db_instance)
      do_get
    end
  
    it "should assign the found DbInstances for the view" do
      do_get
      assigns[:db_instance].should equal(@db_instance)
    end
  end

  describe "handling POST /db_instances" do

    before(:each) do
      @db_instance = mock_model(DbInstance, :to_param => "1")
      DbInstance.stub!(:new).and_return(@db_instance)
    end
    
    describe "with successful save" do
  
      def do_post
        @db_instance.should_receive(:save).and_return(true)
        post :create, :db_instance => {}
      end
  
      it "should create a new db_instance" do
        DbInstance.should_receive(:new).with({}).and_return(@db_instance)
        do_post
      end

      it "should redirect to the new db_instance" do
        do_post
        response.should redirect_to(db_instance_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @db_instance.should_receive(:save).and_return(false)
        post :create, :db_instance => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /db_instances/1" do

    before(:each) do
      @db_instance = mock_model(DbInstance, :to_param => "1")
      DbInstance.stub!(:find).and_return(@db_instance)
    end
    
    describe "with successful update" do

      def do_put
        @db_instance.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the db_instance requested" do
        DbInstance.should_receive(:find).with("1").and_return(@db_instance)
        do_put
      end

      it "should update the found db_instance" do
        do_put
        assigns(:db_instance).should equal(@db_instance)
      end

      it "should assign the found db_instance for the view" do
        do_put
        assigns(:db_instance).should equal(@db_instance)
      end

      it "should redirect to the db_instance" do
        do_put
        response.should redirect_to(db_instance_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @db_instance.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /db_instances/1" do

    before(:each) do
      @db_instance = mock_model(DbInstance, :destroy => true)
      DbInstance.stub!(:find).and_return(@db_instance)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the db_instance requested" do
      DbInstance.should_receive(:find).with("1").and_return(@db_instance)
      do_delete
    end
  
    it "should call destroy on the found db_instance" do
      @db_instance.should_receive(:destroy).and_return(true) 
      do_delete
    end
  
    it "should redirect to the db_instances list" do
      do_delete
      response.should redirect_to(db_instances_url)
    end
  end
end
