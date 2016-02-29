class SaudesController < ApplicationController
  # GET /saudes
  # GET /saudes.xml

  before_filter :load_alunos

  def index
    @saudes = Saude.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @saudes }
    end
  end

  # GET /saudes/1
  # GET /saudes/1.xml
  def show
    @saude = Saude.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @saude }
    end
  end

  # GET /saudes/new
  # GET /saudes/new.xml
  def new
    @saude = Saude.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @saude }
    end
  end

  # GET /saudes/1/edit
  def edit
    @saude = Saude.find(params[:id])
  end

  # POST /saudes
  # POST /saudes.xml
  def create
    @saude = Saude.new(params[:saude])

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
  end

  # PUT /saudes/1
  # PUT /saudes/1.xml
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

  # DELETE /saudes/1
  # DELETE /saudes/1.xml
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
    #Inicialização variavel / combobox grupo

  def load_alunos
    @pessoas_aluno =  Aluno.find(:all, :conditions=> ['unidade_id=?', current_user.unidade_id],:order => "aluno_nome")

  end

end
