class SaudesController < ApplicationController
  before_filter :load_alunos

  def index
    @saudes = Saude.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @saudes }
    end
  end

  def show
    @saude = Saude.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @saude }
    end
  end

  def new_continua
    @saude = Saude.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @saude }
    end
  end

  def new
    @saude = Saude.new
    session[:continua_saude]=0
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @saude }
    end
  end


  def edit
    @saude = Saude.find(params[:id])
  end

  def create
    @saude = Saude.new(params[:saude])
    if session[:continua_saude]==1
       @saude.aluno_id = session[:alunoid_cadastro]
    end
    
    respond_to do |format|
      if @saude.save
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@saude) }
        format.xml  { render :xml => @saude, :status => :created, :location => @saude }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @saude.errors, :status => :unprocessable_entity }
      end
    end
  session[:continua_saude]=0
  session[:continua_economico]=1
  end

  def update
    @saude = Saude.find(params[:id])

    respond_to do |format|
      if @saude.update_attributes(params[:saude])
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@saude) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @saude.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @saude = Saude.find(params[:id])
    @saude.destroy

    respond_to do |format|
      format.html { redirect_to(saudes_url) }
      format.xml  { head :ok }
    end
  end

   def impressao_saude
       @saude = Saude.find(:all,:conditions => ["id = ?",  session[:saude]])
       
      render :layout => "impressao"
end  


   def verifica_dados_aluno
    @dados = Pessoa.find(params[:saude_pessoa_id])
    render :partial => 'exibe_dados'

  end

  protected

  def load_alunos
    @pessoas_aluno =  Aluno.find(:all, :select => "alunos.id, alunos.aluno_nome", :conditions=> ['alunos.unidade_id=? AND (alunos.id NOT IN (SELECT saudes.aluno_id FROM saudes))', current_user.unidade_id],:order => "alunos.aluno_nome")
  end

end
