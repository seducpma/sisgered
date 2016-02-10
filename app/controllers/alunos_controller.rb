class AlunosController < ApplicationController
  # GET /alunos
  # GET /alunos.xml

  before_filter :load_pessoas


  def index
    @alunos = Aluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alunos }
    end
  end

  # GET /alunos/1
  # GET /alunos/1.xml
  def show
    @aluno = Aluno.find(params[:id])
    #maeid = @aluno.aluno_mae_pessoa_id
   # @mae = Pessoa.find.pessoa_nome( :conditions => ["id = ?", maeid])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aluno }
    end
  end

  # GET /alunos/new
  # GET /alunos/new.xml
  def new
    @aluno = Aluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aluno }
    end
  end

  # GET /alunos/1/edit
  def edit
    @aluno = Aluno.find(params[:id])
  end

  # POST /alunos
  # POST /alunos.xml
  def create
       user = current_user.unidade_id
    @aluno = Aluno.new(params[:aluno])

    respond_to do |format|
      if @aluno.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@aluno) }
        format.xml  { render :xml => @aluno, :status => :created, :location => @aluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /alunos/1
  # PUT /alunos/1.xml
  def update
    @aluno = Aluno.find(params[:id])

    respond_to do |format|
      if @aluno.update_attributes(params[:aluno])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@aluno) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /alunos/1
  # DELETE /alunos/1.xml
  def destroy
    @aluno = Aluno.find(params[:id])
    @aluno.destroy

    respond_to do |format|
      format.html { redirect_to(alunos_url) }
      format.xml  { head :ok }
    end

  end

 def impressao_alunos
       @aluno = Aluno.find(:all,:conditions => ["id = ?",  session[:aluno]])
       
      render :layout => "impressao"
end  

 def verifica_dados_aluno
    @dados = Pessoa.find(params[:aluno_pessoa_id])
    render :partial => 'exibe_dados_aluno'

  end


  def verifica_dados_responsavel
    @dados = Pessoa.find(params[:aluno_aluno_responsavel_pessoa_id])
    render :partial => 'exibe_dados'
  end

 

def consulta_ficha_cadastral
     session[:pessoa] = params[:aluno][:pessoa_id]

       @dados = Pessoa.find(:all,:conditions =>['id = ?', session[:pessoa]])
       @aluno = Aluno.find(:all,:conditions =>['pessoa_id = ?', session[:pessoa]])
       @saude = Saude.find(:all,:conditions =>['pessoa_id = ?', session[:pessoa]])
       @socioeconomico = Socioeconomico.find(:all,:conditions =>['pessoa_id = ?', session[:pessoa]])


       render :update do |page|
          page.replace_html 'ficha', :partial => 'dados_ficha_cadastral'
       end
end

def impressao_ficha
       @socioeconomico = Socioeconomico.find(:all,:conditions => ["id = ?",  session[:socioeconomico]])
       @dados = Pessoa.find(:all, :conditions => ["id = ?", session[:pessoa]])
       teste =session[:pessoa]
       @saude = Saude.find(:all,:conditions => ["pessoa_id = ?",  session[:pessoa]])
       @aluno = Aluno.find(:all, :conditions => ["pessoa_id = ?", session[:pessoa]])
      render :layout => "impressao"
end

  def dados_pai
    session[:reside] = params[:aluno_aluno_reside_com]
        if ( (session[:reside] == 'PAI' ))then
          render :update do |page|
             page.replace_html 'mostra_dados_pai', :partial => 'em_branco'
             page.replace_html 'mostra_dados_responsavel', :partial => 'em_branco'
           end
        end
        if ( (session[:reside] == 'MAE' ))then
           render :update do |page|
             page.replace_html 'mostra_dados_mae', :partial => 'em_branco'
             page.replace_html 'mostra_dados_responsavel', :partial => 'em_branco'
           end
        end
        if ( (session[:reside] == 'RESPONSAVEL' ))then

           render :update do |page|

               page.replace_html 'mostra_dados_pai' 
               page.replace_html 'mostra_dados_mae' 
           end
        end
        if ( (session[:reside] == 'PAIS' ))then
          render :update do |page|
             page.replace_html 'mostra_dados_pai', :partial => 'em_branco'
             page.replace_html 'mostra_dados_mae', :partial => 'em_branco'
             page.replace_html 'mostra_dados_responsavel', :partial => 'em_branco'
           end
        end
  end


   protected
    #Inicialização variavel / combobox grupo

  def load_pessoas

    @pessoas_aluno =  Aluno.find(:all, :conditions=> ['unidade_id = ?', current_user.unidade_id],:order => "aluno_nome")

    #@pessoas_mae =  Pessoa.find(:all, :conditions=> ['pessoa_tipo = "MÃE"'],:order => "pessoa_nome")
    #@pessoas_pai =  Pessoa.find(:all, :conditions=> ['pessoa_tipo = "PAI"'],:order => "pessoa_nome")
    #@pessoas_aluno =  Pessoa.find(:all, :joins => "inner join alunos on pessoas.id = alunos.pessoa_id", :conditions=> ['pessoa_tipo = "ALUNO" and unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
    #@pessoas_responsavel =  Pessoa.find(:all, :joins => "inner join alunos on pessoas.id = alunos.pessoa_id", :conditions=> ['pessoa_tipo = "AVÔ" or pessoa_tipo = "AVÓ" or pessoa_tipo = "ENTEADO(A)" or pessoa_tipo = "OUTROS" or pessoa_tipo = "RESPONSÁVEL" and alunos.unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
    #@pessoas_responsavel =  Pessoa.find(:all, :conditions=> ['(pessoa_tipo = "AVÔ" or pessoa_tipo = "AVÓ" or pessoa_tipo = "ENTEADO(A)" or pessoa_tipo = "OUTROS" or pessoa_tipo = "RESPONSÁVEL") and unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
    #@pessoas_responsavel =  Pessoa.find(:all,, :conditions=> ['alunos.unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
  end


end
