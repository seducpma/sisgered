class AlunosController < ApplicationController
  # GET /alunos
  # GET /alunos.xml

  before_filter :load_alunos


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
    t=(params[:id])

  end

  # POST /alunos
  # POST /alunos.xml
  def create
    user = current_user.unidade_id
    @aluno = Aluno.new(params[:aluno])
    @verifica = Aluno.find_by_aluno_nome(@aluno.aluno_nome)
    @verifica2 = Aluno.find_by_aluno_nascimento(@aluno.aluno_nascimento)


    if (@verifica and @verifica2) then
       respond_to do |format|
         format.html { render :action => "new" }
         flash[:notice1] = "ALUNO(A) JÁ CADASTRADO(A)"
    end
    else
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

  def mesmo_nome
    session[:nome] = params[:aluno_aluno_nome]
    t=session[:nome]
    @verifica = Aluno.find_by_aluno_nome(session[:nome])
    if @verifica then
      render :update do |page|
        page.replace_html 'nome_aviso', :text => 'Nome já cadastrado no sistema'
        page.replace_html 'Certeza', :text =>  'Criança ja cadastrada'

    end
    else
      render :update do |page|
        page.replace_html 'nome_aviso', :text => ''
        
      end

    end
  end

 def impressao_alunos
       @aluno = Aluno.find(:all,:conditions => ["id = ?",  session[:aluno]])
       
      render :layout => "impressao"
end

  def impressao_bolsa_familia
      @aluno = Aluno.find(:all,:conditions =>['unidade_id = ? and aluno_bolsa_familia ="SIM" ', current_user.unidade_id ])
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

  def lista_aluno_nome
           @aluno = Aluno.find(:all,:conditions =>['id = ?', params[:aluno_aluno_id]])
           @saude = Saude.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_id]])
           @socioeconomico = Socioeconomico.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_id]])

           render :update do |page|
              page.replace_html 'ficha', :partial => 'dados_ficha_cadastral'
           end

  end

 def lista_aluno_nome


           @aluno = Aluno.find(:all,:conditions =>['id = ?', params[:aluno_aluno_id]])
           @saude = Saude.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_id]])
           @socioeconomico = Socioeconomico.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_id]])
            render :partial =>  'dados_ficha_cadastral'
  end

  def lista_aluno_ra
           @aluno = Aluno.find(:all,:conditions =>['id = ?', params[:aluno_aluno_ra]])
           @saude = Saude.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_ra]])
           @socioeconomico = Socioeconomico.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_ra]])
              render :partial =>  'dados_ficha_cadastral'
  end

  def lista_aluno_rm
          id_rm = params[:aluno_aluno_rm]
           @aluno = Aluno.find(:all,:conditions =>['id = ?', params[:aluno_aluno_rm]])
           @saude = Saude.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_rm]])
           @socioeconomico = Socioeconomico.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_rm]])
              render :partial =>  'dados_ficha_cadastral'
  end


 def nome_classe


       session[:de_para]= 0
       @classe = Classe.find(:all, :joins => "inner join alunos_classes on classes.id = alunos_classes.classe_id", :conditions =>['alunos_classes.aluno_id =?', params[:aluno_aluno_id]])
       if @classe.empty?
         @classe = Classe.find(:all, :joins => "inner join transferencias on classes.id = transferencias.classe_id", :conditions =>['transferencias.aluno_id =?', params[:aluno_aluno_id]])  
         session[:de_para]=1
       end

       @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno_aluno_id]])

        @aluno.each do |aluno|
           session[:trans]= aluno.trans_in
           if aluno.transferido.nil?
                session[:trans_data] = '-- /--/--'
           else
              session[:trans_data] =aluno.transferido.strftime("%d/%m/%Y")
           end
           alunoid = aluno.unidade_anterior
            if (aluno.trans_in == 1)
               
               @unidade=  Unidade.find(alunoid)
                session[:trans_unidade]= @unidade.nome

            end

        end
            
        render  :partial => 'exibe_aluno_classe'
         
  end



def consulta_ficha_cadastral

      if params[:type_of].to_i == 1

       else if params[:type_of].to_i == 2
            else if params[:type_of].to_i == 3
                 else if params[:type_of].to_i == 4
                     if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                         @professors = Professor.find(:all,:conditions => ["nome like ? AND desligado = 0", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
                     else
                         @professors = Professor.find(:all, :conditions=> ["nome like ? and (unidade_id = ? or unidade_id = 54) AND desligado = 0" ,"%" + params[:search1].to_s + "%", current_user.unidade_id], :order => 'unidade_id,nome ASC')
                     end
                     render :update do |page|
                          page.replace_html 'professores', :partial => "professores"
                     end
                 else if params[:type_of].to_i == 5
                         render :update do |page|
                           page.replace_html 'professores', :partial => "professores"
                          end
                      else if params[:type_of].to_i == 6
                               if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                                   @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado = 0", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
                               else
                                   @professors = Professor.find(:all, :conditions=> ["desligado = 0  and funcao like ? and (unidade_id = ? or unidade_id = 54)" ,"%" + params[:search].to_s + "%", current_user.unidade_id], :order => 'unidade_id,nome ASC')
                               end
                               render :update do |page|
                                      page.replace_html 'professores', :partial => "professores"
                               end
                             end
                      end
                 end

            end
       end
    end


end

def editar_ficha_cadastral
       session[:aluno] = params[:aluno][:id]

       @aluno = Aluno.find(:all,:conditions =>['id = ?', session[:aluno]])
       @saude = Saude.find(:all,:conditions =>['aluno_id = ?', session[:aluno]])
       @socioeconomico = Socioeconomico.find(:all,:conditions =>['aluno_id = ?', session[:aluno]])
       render :update do |page|
          page.replace_html 'ficha', :partial => 'dados_ficha_cadastral_editar'
       end
end


def consulta_responsaveis
       session[:aluno] = params[:aluno][:id]
       @aluno = Aluno.find(:all,:conditions =>['id = ?', session[:aluno]])
 
       render :update do |page|
          page.replace_html 'ficha', :partial => 'dados_responsaveis'
       end
end

def consulta_bolsa_familia

    @aluno = Aluno.find(:all,:conditions =>['unidade_id = ? and aluno_bolsa_familia ="SIM" ', current_user.unidade_id ])

end


def impressao_ficha
       @socioeconomico = Socioeconomico.find(:all,:conditions => ["aluno_id = ?",  session[:aluno]])
       @saude = Saude.find(:all,:conditions => ["aluno_id = ?",  session[:aluno]])
       @aluno = Aluno.find(:all, :conditions => ["id = ?", session[:aluno]])
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

  def load_alunos


    if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then

        @alunos =  Aluno.find(:all,:order => "aluno_nome")
        @alunosRA =  Aluno.find(:all,:order => "aluno_ra")
        @alunosRM =  Aluno.find(:all,:order => "aluno_rm")
        @alunos1 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
        @disciplinas = Disciplina.find(:all, :order => 'ordem ASC')
    else

        @alunos =  Aluno.find(:all, :conditions=> ['unidade_id = ?', current_user.unidade_id],:order => "aluno_nome")
        @alunosRA =  Aluno.find(:all, :conditions=> ['unidade_id = ?', current_user.unidade_id],:order => "aluno_ra")
        @alunosRM =  Aluno.find(:all, :conditions=> ['unidade_id = ?', current_user.unidade_id],:order => "aluno_rm")
        @alunos1 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
        @disciplinas = Disciplina.find(:all, :order => 'ordem ASC')
    end
    #@pessoas_mae =  Pessoa.find(:all, :conditions=> ['pessoa_tipo = "MÃE"'],:order => "pessoa_nome")
    #@pessoas_pai =  Pessoa.find(:all, :conditions=> ['pessoa_tipo = "PAI"'],:order => "pessoa_nome")
    #@pessoas_aluno =  Pessoa.find(:all, :joins => "inner join alunos on pessoas.id = alunos.pessoa_id", :conditions=> ['pessoa_tipo = "ALUNO" and unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
    #@pessoas_responsavel =  Pessoa.find(:all, :joins => "inner join alunos on pessoas.id = alunos.pessoa_id", :conditions=> ['pessoa_tipo = "AVÔ" or pessoa_tipo = "AVÓ" or pessoa_tipo = "ENTEADO(A)" or pessoa_tipo = "OUTROS" or pessoa_tipo = "RESPONSÁVEL" and alunos.unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
    #@pessoas_responsavel =  Pessoa.find(:all, :conditions=> ['(pessoa_tipo = "AVÔ" or pessoa_tipo = "AVÓ" or pessoa_tipo = "ENTEADO(A)" or pessoa_tipo = "OUTROS" or pessoa_tipo = "RESPONSÁVEL") and unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
    #@pessoas_responsavel =  Pessoa.find(:all,, :conditions=> ['alunos.unidade_id=?', current_user.unidade_id],:order => "pessoa_nome")
  end


end
