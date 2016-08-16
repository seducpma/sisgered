class SituacaoAlunosController < ApplicationController
  # GET /situacao_alunos
  # GET /situacao_alunos.xml
  def index
    @situacao_alunos = SituacaoAluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @situacao_alunos }
    end
  end

  # GET /situacao_alunos/1
  # GET /situacao_alunos/1.xml
  def show
    @situacao_aluno = SituacaoAluno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @situacao_aluno }
    end
  end

  # GET /situacao_alunos/new
  # GET /situacao_alunos/new.xml
  def new
    @situacao_aluno = SituacaoAluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @situacao_aluno }
    end
  end

  # GET /situacao_alunos/1/edit
  def edit
    @situacao_aluno = SituacaoAluno.find(params[:id])
  end

  # POST /situacao_alunos
  # POST /situacao_alunos.xml
  def create
    @situacao_aluno = SituacaoAluno.new(params[:situacao_aluno])

    respond_to do |format|
      if @situacao_aluno.save
        flash[:notice] = 'SituacaoAluno was successfully created.'
        format.html { redirect_to(@situacao_aluno) }
        format.xml  { render :xml => @situacao_aluno, :status => :created, :location => @situacao_aluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @situacao_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /situacao_alunos/1
  # PUT /situacao_alunos/1.xml
  def update
    @situacao_aluno = SituacaoAluno.find(params[:id])

    respond_to do |format|
      if @situacao_aluno.update_attributes(params[:situacao_aluno])
        flash[:notice] = 'SituacaoAluno was successfully updated.'
        format.html { redirect_to(@situacao_aluno) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @situacao_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /situacao_alunos/1
  # DELETE /situacao_alunos/1.xml
  def destroy
    @situacao_aluno = SituacaoAluno.find(params[:id])
    @situacao_aluno.destroy

    respond_to do |format|
      format.html { redirect_to(situacao_alunos_url) }
      format.xml  { head :ok }
    end
  end
end
