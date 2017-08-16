class EventualsController < ApplicationController
  # GET /eventuals
  # GET /eventuals.xml
  def index
    @eventuals = Eventual.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @eventuals }
    end
  end

  # GET /eventuals/1
  # GET /eventuals/1.xml
  def show
    @eventual = Eventual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @eventual }
    end
  end

  # GET /eventuals/new
  # GET /eventuals/new.xml
  def new
    @eventual = Eventual.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @eventual }
    end
  end

  # GET /eventuals/1/edit
  def edit
    @eventual = Eventual.find(params[:id])
  end

  # POST /eventuals
  # POST /eventuals.xml
  def create
    @eventual = Eventual.new(params[:eventual])

    respond_to do |format|
      if @eventual.save
        flash[:notice] = 'Eventual was successfully created.'
        format.html { redirect_to(@eventual) }
        format.xml  { render :xml => @eventual, :status => :created, :location => @eventual }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @eventual.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /eventuals/1
  # PUT /eventuals/1.xml
  def update
    @eventual = Eventual.find(params[:id])

    respond_to do |format|
      if @eventual.update_attributes(params[:eventual])
        flash[:notice] = 'Eventual was successfully updated.'
        format.html { redirect_to(@eventual) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @eventual.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /eventuals/1
  # DELETE /eventuals/1.xml
  def destroy
    @eventual = Eventual.find(params[:id])
    @eventual.destroy

    respond_to do |format|
      format.html { redirect_to(eventuals_url) }
      format.xml  { head :ok }
    end
  end
end
