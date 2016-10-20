class ObservacaoNotasController < ApplicationController

  before_filter :load_iniciais

  # GET /observacao_notas
  # GET /observacao_notas.xml
  def index
    @observacao_notas = ObservacaoNota.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @observacao_notas }
    end
  end

  # GET /observacao_notas/1
  # GET /observacao_notas/1.xml
  def show
    @observacao_nota = ObservacaoNota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @observacao_nota }
    end
  end

  # GET /observacao_notas/new
  # GET /observacao_notas/new.xml
  def new
    @observacao_nota = ObservacaoNota.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @observacao_nota }
    end
  end

  # GET /observacao_notas/1/edit
  def edit
    @observacao_nota = ObservacaoNota.find(params[:id])
  end

  # POST /observacao_notas
  # POST /observacao_notas.xml
  def create
    @observacao_nota = ObservacaoNota.new(params[:observacao_nota])
    @observacao_nota.ano_letivo =  Time.now.year
    respond_to do |format|
      if @observacao_nota.save
        flash[:notice] = 'ObservacaoNota was successfully created.'
        format.html { redirect_to(@observacao_nota) }
        format.xml  { render :xml => @observacao_nota, :status => :created, :location => @observacao_nota }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @observacao_nota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /observacao_notas/1
  # PUT /observacao_notas/1.xml
  def update
    @observacao_nota = ObservacaoNota.find(params[:id])

    respond_to do |format|
      if @observacao_nota.update_attributes(params[:observacao_nota])
        flash[:notice] = 'ObservacaoNota was successfully updated.'
        format.html { redirect_to(@observacao_nota) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @observacao_nota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /observacao_notas/1
  # DELETE /observacao_notas/1.xml
  def destroy
    @observacao_nota = ObservacaoNota.find(params[:id])
    @observacao_nota.destroy

 respond_to do |format|
      format.html { redirect_to(voltar_lancamento_notas_path)}
      format.xml  { head :ok }
    end

  end

  def aluno_classe
    session[:aluno]= params[:observacao_nota_aluno_id]
    @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo = ?",params[:observacao_nota_aluno_id], Time.now.year ])
    for matricula in @matricula
     session[:classe]= matricula.classe.classe_classe
     session[:periodo] = matricula.classe.horario
    end
t=0
    render :partial => 'aluno_classe'



  end


  def load_iniciais
    @quem = ["CONSELHO","DIREÇÂO","PEDAGOGO",]
    @alunos = Aluno.find(:all, :conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
  end

  

end
