class AtendimentoAeesController < ApplicationController
  # GET /atendimento_aees
  # GET /atendimento_aees.xml
  def index
    @atendimento_aees = AtendimentoAee.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atendimento_aees }
    end
  end

  # GET /atendimento_aees/1
  # GET /atendimento_aees/1.xml
  def show
    @atendimento_aee = AtendimentoAee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atendimento_aee }
    end
  end

  # GET /atendimento_aees/new
  # GET /atendimento_aees/new.xml
  def new
    @atendimento_aee = AtendimentoAee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atendimento_aee }
    end
  end

  # GET /atendimento_aees/1/edit
  def edit
    @atendimento_aee = AtendimentoAee.find(params[:id])
  end

  # POST /atendimento_aees
  # POST /atendimento_aees.xml
  def create
    @atendimento_aee = AtendimentoAee.new(params[:atendimento_aee])

    respond_to do |format|
      if @atendimento_aee.save
          @atendimento_aee.classe_mat= session[:cclasse_id]
          @atendimento_aee.aluno_id  = session[:aaluno_id]
          @atendimento_aee.unidade  = session[:uunidade]
          @atendimento_aee.ano_letivo = Time.now.year
          @atendimento_aee.save
        flash[:notice] = 'Atendimento AEE Cadastrado.'
        format.html { redirect_to(@atendimento_aee) }
        format.xml  { render :xml => @atendimento_aee, :status => :created, :location => @atendimento_aee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @atendimento_aee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /atendimento_aees/1
  # PUT /atendimento_aees/1.xml
  def update
    @atendimento_aee = AtendimentoAee.find(params[:id])

    respond_to do |format|
      if @atendimento_aee.update_attributes(params[:atendimento_aee])
        flash[:notice] = 'AtendimentoAee was successfully updated.'
        format.html { redirect_to(@atendimento_aee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @atendimento_aee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimento_aees/1
  # DELETE /atendimento_aees/1.xml
  def destroy
    @atendimento_aee = AtendimentoAee.find(params[:id])
    @atendimento_aee.destroy

    respond_to do |format|
      format.html { redirect_to(atendimento_aees_url) }
      format.xml  { head :ok }
    end
  end

  def aluno_classe
        w= params[:aluno_id]
          
         @matricula= Matricula.find(:all, :conditions=> ['aluno_id = ? AND (status =? OR status =?) AND ano_letivo =?' , params[:aluno_id],"MATRICULADO","TRANSFERENCIA", Time.now.year	])
         session[:aaluno_id] = params[:aluno_id]
         session[:cclasse_id]= @matricula[0].classe.classe_classe
         session[:uunidade] = @matricula[0].unidade.nome
      render :partial => 'aluno_classe'
  end

end
