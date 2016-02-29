class AlunosClassesController < ApplicationController
  # GET /classes_alunos
  # GET /classes_alunos.xml
  def index
    @classes_alunos = ClassesAluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classes_alunos }
    end
  end

  # GET /classes_alunos/1
  # GET /classes_alunos/1.xml
  def show
    @classes_aluno = ClassesAluno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @classes_aluno }
    end
  end

  # GET /classes_alunos/new
  # GET /classes_alunos/new.xml
  def new
    @classes_aluno = ClassesAluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @classes_aluno }
    end
  end

  # GET /classes_alunos/1/edit
  def edit
    @classes_aluno = ClassesAluno.find(params[:id])
  end

  # POST /classes_alunos
  # POST /classes_alunos.xml
  def create
    @classes_aluno = ClassesAluno.new(params[:classes_aluno])

    respond_to do |format|
      if @classes_aluno.save
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classes_aluno) }
        format.xml  { render :xml => @classes_aluno, :status => :created, :location => @classes_aluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @classes_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /classes_alunos/1
  # PUT /classes_alunos/1.xml
  def update
    @classes_aluno = ClassesAluno.find(params[:id])

    respond_to do |format|
      if @classes_aluno.update_attributes(params[:classes_aluno])
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classes_aluno) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @classes_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /classes_alunos/1
  # DELETE /classes_alunos/1.xml
  def destroy
    @classes_aluno = ClassesAluno.find(params[:id])
    @classes_aluno.destroy

    respond_to do |format|
      format.html { redirect_to(classes_alunos_url) }
      format.xml  { head :ok }
    end
  end
end
