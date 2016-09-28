class ObservacaoHistoricosController < ApplicationController
  # GET /observacao_historicos
  # GET /observacao_historicos.xml
  def index
    @observacao_historicos = ObservacaoHistorico.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @observacao_historicos }
    end
  end

  # GET /observacao_historicos/1
  # GET /observacao_historicos/1.xml
  def show
    @observacao_historico = ObservacaoHistorico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @observacao_historico }
    end
  end

  # GET /observacao_historicos/new
  # GET /observacao_historicos/new.xml
  def new
    @observacao_historico = ObservacaoHistorico.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @observacao_historico }
    end
  end

  # GET /observacao_historicos/1/edit
  def edit
    @observacao_historico = ObservacaoHistorico.find(params[:id])
  end

  # POST /observacao_historicos
  # POST /observacao_historicos.xml
  def create
    @observacao_historico = ObservacaoHistorico.new(params[:observacao_historico])

    respond_to do |format|
      if @observacao_historico.save
        flash[:notice] = 'ObservacaoHistorico was successfully created.'
        format.html { redirect_to(@observacao_historico) }
        format.xml  { render :xml => @observacao_historico, :status => :created, :location => @observacao_historico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @observacao_historico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /observacao_historicos/1
  # PUT /observacao_historicos/1.xml
  def update
    @observacao_historico = ObservacaoHistorico.find(params[:id])

    respond_to do |format|
      if @observacao_historico.update_attributes(params[:observacao_historico])
        flash[:notice] = 'ObservacaoHistorico was successfully updated.'
        format.html { redirect_to(@observacao_historico) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @observacao_historico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /observacao_historicos/1
  # DELETE /observacao_historicos/1.xml
  def destroy
    @observacao_historico = ObservacaoHistorico.find(params[:id])
    @observacao_historico.destroy

    respond_to do |format|
      format.html { redirect_to(observacao_historicos_url) }
      format.xml  { head :ok }
    end
  end
end