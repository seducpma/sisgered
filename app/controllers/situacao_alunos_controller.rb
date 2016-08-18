class SituacaoAlunosController < ApplicationController
  
  def index
    @situacao_alunos = SituacaoAluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @situacao_alunos }
    end
  end

  def show
    @situacao_aluno = SituacaoAluno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @situacao_aluno }
    end
  end

  def new
    @situacao_aluno = SituacaoAluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @situacao_aluno }
    end
  end


  def edit
    @situacao_aluno = SituacaoAluno.find(params[:id])
  end

  def create
    @situacao_aluno = SituacaoAluno.new(params[:situacao_aluno])

    respond_to do |format|
      if @situacao_aluno.save
        flash[:notice] = 'SALVO COM SUCESSO'
        format.html { redirect_to(@situacao_aluno) }
        format.xml  { render :xml => @situacao_aluno, :status => :created, :location => @situacao_aluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @situacao_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @situacao_aluno = SituacaoAluno.find(params[:id])

    respond_to do |format|
      if @situacao_aluno.update_attributes(params[:situacao_aluno])
        flash[:notice] = 'SALVO COM SUCESSO'
        format.html { redirect_to(@situacao_aluno) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @situacao_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @situacao_aluno = SituacaoAluno.find(params[:id])
    @situacao_aluno.destroy

    respond_to do |format|
      format.html { redirect_to(situacao_alunos_url) }
      format.xml  { head :ok }
    end
  end
end
