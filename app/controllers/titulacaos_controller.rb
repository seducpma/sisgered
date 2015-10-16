class TitulacaosController < ApplicationController
  # GET /titulacaos
  # GET /titulacaos.xml
  def index
    @titulacaos = Titulacao.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titulacaos }
    end
  end

  # GET /titulacaos/1
  # GET /titulacaos/1.xml
  def show
    @titulacao = Titulacao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @titulacao }
    end
  end

  # GET /titulacaos/new
  # GET /titulacaos/new.xml
  def new
    @titulacao = Titulacao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @titulacao }
    end
  end

  # GET /titulacaos/1/edit
  def edit
    @titulacao = Titulacao.find(params[:id])
  end

  # POST /titulacaos
  # POST /titulacaos.xml
  def create
    @titulacao = Titulacao.new(params[:titulacao])

    respond_to do |format|
      if @titulacao.save
        flash[:notice] = 'Titulacao was successfully created.'
        format.html { redirect_to(@titulacao) }
        format.xml  { render :xml => @titulacao, :status => :created, :location => @titulacao }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @titulacao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /titulacaos/1
  # PUT /titulacaos/1.xml
  def update
    @titulacao = Titulacao.find(params[:id])

    respond_to do |format|
      if @titulacao.update_attributes(params[:titulacao])
        flash[:notice] = 'Titulacao was successfully updated.'
        format.html { redirect_to(@titulacao) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @titulacao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /titulacaos/1
  # DELETE /titulacaos/1.xml
  def destroy
    @titulacao = Titulacao.find(params[:id])
    @titulacao.destroy

    respond_to do |format|
      format.html { redirect_to(titulacaos_url) }
      format.xml  { head :ok }
    end
  end
end
