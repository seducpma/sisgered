class AtribuicaosController < ApplicationController
  # GET /atribuicaos
  # GET /atribuicaos.xml

 before_filter :load_professors
  before_filter :load_classes



  def index
    @atribuicaos = Atribuicao.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atribuicaos }
    end
  end

  # GET /atribuicaos/1
  # GET /atribuicaos/1.xml
  def show
    @atribuicao = Atribuicao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atribuicao }
    end
  end

  # GET /atribuicaos/new
  # GET /atribuicaos/new.xml
  def new
    @atribuicao = Atribuicao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atribuicao }
    end
  end

  # GET /atribuicaos/1/edit
  def edit
    @atribuicao = Atribuicao.find(params[:id])
  end

  # POST /atribuicaos
  # POST /atribuicaos.xml
  def create
    @atribuicao = Atribuicao.new(params[:atribuicao])

    respond_to do |format|
      if @atribuicao.save
        flash[:notice] = 'Atribuicao was successfully created.'
        format.html { redirect_to(@atribuicao) }
        format.xml  { render :xml => @atribuicao, :status => :created, :location => @atribuicao }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /atribuicaos/1
  # PUT /atribuicaos/1.xml
  def update
    @atribuicao = Atribuicao.find(params[:id])

    respond_to do |format|
      if @atribuicao.update_attributes(params[:atribuicao])
        flash[:notice] = 'Atribuicao was successfully updated.'
        format.html { redirect_to(@atribuicao) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /atribuicaos/1
  # DELETE /atribuicaos/1.xml
  def destroy

    @atribuicao = Atribuicao.find(params[:id])
    @atribuicao.destroy

    respond_to do |format|
      format.html { redirect_to(atribuicaos_url) }
      format.xml  { head :ok }
    end
  end

   def load_classes
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classes = Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
    end
 end

   def load_professors
    if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @professors = Professor.find(:all, :order => 'nome ASC')
    else
        @professors = Professor.find(:all, :conditions => ['unidade_id = ? or unidade_id = 54', current_user.unidade_id  ],:order => 'nome ASC')
    end
  end


end
