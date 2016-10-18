class UfaltasController < ApplicationController
  # GET /ufaltas
  # GET /ufaltas.xml
  def index
    @ufaltas = Ufalta.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ufaltas }
    end
  end

  # GET /ufaltas/1
  # GET /ufaltas/1.xml
  def show
    @ufalta = Ufalta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ufalta }
    end
  end

  # GET /ufaltas/new
  # GET /ufaltas/new.xml
  def new
    @ufalta = Ufalta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ufalta }
    end
  end

  # GET /ufaltas/1/edit
  def edit
    @ufalta = Ufalta.find(params[:id])
  end

  # POST /ufaltas
  # POST /ufaltas.xml
  def create
    @ufalta = Ufalta.new(params[:ufalta])

    respond_to do |format|
      if @ufalta.save
        flash[:notice] = 'Ufalta was successfully created.'
        format.html { redirect_to(@ufalta) }
        format.xml  { render :xml => @ufalta, :status => :created, :location => @ufalta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ufalta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ufaltas/1
  # PUT /ufaltas/1.xml
  def update
    @ufalta = Ufalta.find(params[:id])

    respond_to do |format|
      if @ufalta.update_attributes(params[:ufalta])
        flash[:notice] = 'Ufalta was successfully updated.'
        format.html { redirect_to(@ufalta) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ufalta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ufaltas/1
  # DELETE /ufaltas/1.xml
  def destroy
    @ufalta = Ufalta.find(params[:id])
    @ufalta.destroy

    respond_to do |format|
      format.html { redirect_to(ufaltas_url) }
      format.xml  { head :ok }
    end
  end
end
