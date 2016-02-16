class NotasAlunosController < ApplicationController
  # GET /notas_alunos
  # GET /notas_alunos.xml
  def index
    @notas_alunos = NotasAluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notas_alunos }
    end
  end

  # GET /notas_alunos/1
  # GET /notas_alunos/1.xml
  def show
    @notas_aluno = NotasAluno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notas_aluno }
    end
  end

  # GET /notas_alunos/new
  # GET /notas_alunos/new.xml
  def new
    @notas_aluno = NotasAluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notas_aluno }
    end
  end

  # GET /notas_alunos/1/edit
  def edit
    @notas_aluno = NotasAluno.find(params[:id])
  end

  # POST /notas_alunos
  # POST /notas_alunos.xml
  def create
    @notas_aluno = NotasAluno.new(params[:notas_aluno])

    respond_to do |format|
      if @notas_aluno.save
        flash[:notice] = 'NotasAluno was successfully created.'
        format.html { redirect_to(@notas_aluno) }
        format.xml  { render :xml => @notas_aluno, :status => :created, :location => @notas_aluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notas_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notas_alunos/1
  # PUT /notas_alunos/1.xml
  def update
    @notas_aluno = NotasAluno.find(params[:id])

    respond_to do |format|
      if @notas_aluno.update_attributes(params[:notas_aluno])
        flash[:notice] = 'NotasAluno was successfully updated.'
        format.html { redirect_to(@notas_aluno) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notas_aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notas_alunos/1
  # DELETE /notas_alunos/1.xml
  def destroy
    @notas_aluno = NotasAluno.find(params[:id])
    @notas_aluno.destroy

    respond_to do |format|
      format.html { redirect_to(notas_alunos_url) }
      format.xml  { head :ok }
    end
  end
end
