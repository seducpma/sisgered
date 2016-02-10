class SocioeconomicosController < ApplicationController
  # GET /socioeconomicos
  # GET /socioeconomicos.xml

   before_filter :load_alunos

  def index
    @socioeconomicos = Socioeconomico.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @socioeconomicos }
    end
  end

  # GET /socioeconomicos/1
  # GET /socioeconomicos/1.xml
  def show
    @socioeconomico = Socioeconomico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @socioeconomico }
    end
  end

  # GET /socioeconomicos/new
  # GET /socioeconomicos/new.xml
  def new
    @socioeconomico = Socioeconomico.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @socioeconomico }
    end
  end

  # GET /socioeconomicos/1/edit
  def edit
    @socioeconomico = Socioeconomico.find(params[:id])
  end

  # POST /socioeconomicos
  # POST /socioeconomicos.xml
  def create
    @socioeconomico = Socioeconomico.new(params[:socioeconomico])

    respond_to do |format|
      if @socioeconomico.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@socioeconomico) }
        format.xml  { render :xml => @socioeconomico, :status => :created, :location => @socioeconomico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @socioeconomico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /socioeconomicos/1
  # PUT /socioeconomicos/1.xml
  def update
    @socioeconomico = Socioeconomico.find(params[:id])

    respond_to do |format|
      if @socioeconomico.update_attributes(params[:socioeconomico])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@socioeconomico) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @socioeconomico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /socioeconomicos/1
  # DELETE /socioeconomicos/1.xml
  def destroy
    @socioeconomico = Socioeconomico.find(params[:id])
    @socioeconomico.destroy

    respond_to do |format|
      format.html { redirect_to(socioeconomicos_url) }
      format.xml  { head :ok }
    end
  end


def impressao_socioeconomico
       @socioeconomico = Socioeconomico.find(:all,:conditions => ["id = ?",  session[:socioeconomico]])
      
      render :layout => "impressao"
end

def impressao_ficha_completa

       @socioeconomico = Socioeconomico.find(:all,:conditions => ["id = ?",  session[:socioeconomico]])
       #@pessoa = Pessoa.find(:all, :conditions => ["id = ?", session[:pessoa]])

       @saude = Saude.find(:all,:conditions => ["aluno_id = ?",  session[:aluno]])
       @aluno = Aluno.find(:all, :conditions => ["id = ?", session[:aluno]])
   

      render :layout => "impressao"
end


  protected
    #Inicialização variavel / combobox grupo

  def load_alunos
    @pessoas_aluno =  Aluno.find(:all, :conditions=> ['unidade_id=?', current_user.unidade_id],:order => "aluno_nome")
  end


end
