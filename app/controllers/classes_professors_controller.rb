class ClassesProfessorsController < ApplicationController
  # GET /classes_professors
  # GET /classes_professors.xml
  def index
    @classes_professors = ClassesProfessor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classes_professors }
    end
  end

  # GET /classes_professors/1
  # GET /classes_professors/1.xml
  def show
    @classes_professor = ClassesProfessor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @classes_professor }
    end
  end

  # GET /classes_professors/new
  # GET /classes_professors/new.xml
  def new
    @classes_professor = ClassesProfessor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @classes_professor }
    end
  end

  # GET /classes_professors/1/edit
  def edit
    @classes_professor = ClassesProfessor.find(params[:id])
  end

  # POST /classes_professors
  # POST /classes_professors.xml
  def create
    @classes_professor = ClassesProfessor.new(params[:classes_professor])

    respond_to do |format|
      if @classes_professor.save
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classes_professor) }
        format.xml  { render :xml => @classes_professor, :status => :created, :location => @classes_professor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @classes_professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /classes_professors/1
  # PUT /classes_professors/1.xml
  def update
    @classes_professor = ClassesProfessor.find(params[:id])

    respond_to do |format|
      if @classes_professor.update_attributes(params[:classes_professor])
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classes_professor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @classes_professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /classes_professors/1
  # DELETE /classes_professors/1.xml
  def destroy
    @classes_professor = ClassesProfessor.find(params[:id])
    @classes_professor.destroy

    respond_to do |format|
      format.html { redirect_to(classes_professors_url) }
      format.xml  { head :ok }
    end
  end
end
