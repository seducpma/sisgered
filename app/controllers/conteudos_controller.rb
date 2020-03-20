class ConteudosController < ApplicationController
  # GET /conteudos
  # GET /conteudos.xml
  def index
    @conteudos = Conteudo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conteudos }
    end
  end

  # GET /conteudos/1
  # GET /conteudos/1.xml
  def show
    @conteudo = Conteudo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end

  # GET /conteudos/new
  # GET /conteudos/new.xml
  def new
    @conteudo = Conteudo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end

  # GET /conteudos/1/edit
  def edit
    @conteudo = Conteudo.find(params[:id])
  end

  # POST /conteudos
  # POST /conteudos.xml
  def create
    @conteudo = Conteudo.new(params[:conteudo])

    respond_to do |format|
      if @conteudo.save
        flash[:notice] = 'Conteudo was successfully created.'
        format.html { redirect_to(@conteudo) }
        format.xml  { render :xml => @conteudo, :status => :created, :location => @conteudo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conteudo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conteudos/1
  # PUT /conteudos/1.xml
  def update
    @conteudo = Conteudo.find(params[:id])

    respond_to do |format|
      if @conteudo.update_attributes(params[:conteudo])
        flash[:notice] = 'Conteudo was successfully updated.'
        format.html { redirect_to(@conteudo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conteudo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conteudos/1
  # DELETE /conteudos/1.xml
  def destroy
    @conteudo = Conteudo.find(params[:id])
    @conteudo.destroy

    respond_to do |format|
      format.html { redirect_to(conteudos_url) }
      format.xml  { head :ok }
    end
  end
end
