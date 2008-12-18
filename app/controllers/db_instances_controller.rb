class DbInstancesController < ApplicationController
  add_crumb('Database Instances') { |instance| instance.send :db_instances_path }
  
  # GET /db_instances
  # GET /db_instances.xml
  def index
    @db_instances = DbInstance.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @db_instances }
    end
  end

  # GET /db_instances/1
  # GET /db_instances/1.xml
  def show
    @db_instance = DbInstance.find(params[:id])
    
    respond_to do |format|
      format.html do # show.html.erb
        add_crumb @db_instance.to_s
      end
      format.xml  { render :xml => @db_instance }
    end
  end

  # GET /db_instances/new
  # GET /db_instances/new.xml
  def new
    @db_instance = DbInstance.new

    respond_to do |format|
      format.html do # new.html.erb
        add_crumb 'New'
      end
      format.xml  { render :xml => @db_instance }
    end
  end

  # GET /db_instances/1/edit
  def edit
    @db_instance = DbInstance.find(params[:id])
    
    add_crumb @db_instance.to_s, db_instance_path(@db_instance)
    add_crumb 'Edit'
  end

  # POST /db_instances
  # POST /db_instances.xml
  def create
    @db_instance = DbInstance.new(params[:db_instance])

    respond_to do |format|
      if @db_instance.save
        flash[:notice] = 'Database instance was successfully created.'
        format.html { redirect_to db_instances_path }
        format.xml  { render :xml => @db_instance, :status => :created, :location => @db_instance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @db_instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /db_instances/1
  # PUT /db_instances/1.xml
  def update
    @db_instance = DbInstance.find(params[:id])

    respond_to do |format|
      if @db_instance.update_attributes(params[:db_instance])
        flash[:notice] = 'Datanase instance was successfully updated.'
        format.html { redirect_to db_instances_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @db_instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /db_instances/1
  # DELETE /db_instances/1.xml
  def destroy
    @db_instance = DbInstance.find(params[:id])
    @db_instance.destroy

    respond_to do |format|
      format.html { redirect_to(db_instances_url) }
      format.xml  { head :ok }
    end
  end
end
