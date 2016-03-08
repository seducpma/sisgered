class TransferenciasController < ApplicationController
  # GET /transferencias
  # GET /transferencias.xml

    before_filter :load_unidades


  def index
    @transferencias = Transferencia.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transferencias }
    end
  end

  # GET /transferencias/1
  # GET /transferencias/1.xml
  def show
    @transferencia = Transferencia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transferencia }
    end
  end

  # GET /transferencias/new
  # GET /transferencias/new.xml
  def new
    @transferencia = Transferencia.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transferencia }
    end
  end

  # GET /transferencias/1/edit
  def edit
    @transferencia = Transferencia.find(params[:id])
  end

  # POST /transferencias
  # POST /transferencias.xml
  def create
    @transferencia = Transferencia.new(params[:transferencia])

    respond_to do |format|
      if @transferencia.save
        flash[:notice] = 'Transferencia was successfully created.'
        format.html { redirect_to(@transferencia) }
        format.xml  { render :xml => @transferencia, :status => :created, :location => @transferencia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transferencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transferencias/1
  # PUT /transferencias/1.xml
  def update
    @transferencia = Transferencia.find(params[:id])

    respond_to do |format|
      if @transferencia.update_attributes(params[:transferencia])
        flash[:notice] = 'Transferencia was successfully updated.'
        format.html { redirect_to(@transferencia) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transferencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transferencias/1
  # DELETE /transferencias/1.xml
  def destroy
    @transferencia = Transferencia.find(params[:id])
    @transferencia.destroy

    respond_to do |format|
      format.html { redirect_to(transferencias_url) }
      format.xml  { head :ok }
    end
  end


  def consulta_transferencia

  end




  def unidade_transferencia
   unidade_id = Unidade.find_by_nome(params[:transferencia_de])
   @alunos = Aluno.find(:all, :conditions =>['unidade_id =?',  unidade_id], :order => 'aluno_nome')
   @unidade_para = Unidade.find(:all, :conditions => ['id =?', current_user.unidade_id], :order => 'nome ASC')
    render :partial => 'selecao_alunos'



  end

  def load_unidades
       @unidade_de = Unidade.find(:all, :order => 'nome ASC')
       @unidade_para = Unidade.find(:all, :order => 'nome ASC')
       @alunos = Aluno.find(:all, :order => 'aluno_nome')
  end
end
