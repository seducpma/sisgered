class AlunosController < ApplicationController

 # before_filter :load_alunos

  def index
    @alunos = Aluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alunos }
    end
  end

  def show
    @aluno = Aluno.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aluno }
    end
  end

  def new
    @aluno = Aluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aluno }
    end
  end


  def edit
    @aluno = Aluno.find(params[:id])
    t=(params[:id])

  end

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
        session[:alunoid_cadastro]= @aluno.id
        session[:alunonome_cadastro]= @aluno.aluno_nome
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@aluno) }
        format.xml  { render :xml => @aluno, :status => :created, :location => @aluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aluno.errors, :status => :unprocessable_entity }
      end
     end
  end
  session[:continua_saude]=1
  session[:continua_economico]=0
end

  def update
    
    @aluno = Aluno.find(params[:id])
    @aluno.unidade_id = current_user.unidade_id
    @aluno.aluno_status = nil
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

  def destroy
    @aluno = Aluno.find(params[:id])
    @aluno.destroy

    respond_to do |format|
      format.html { redirect_to(alunos_url) }
      format.xml  { head :ok }
    end

  end

  def construcao
    
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
       @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =?', params[:aluno_aluno_id]])

       if @classe.empty?
         @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =?', params[:aluno_aluno_id]])

         session[:de_para]=1
       end

      @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno_aluno_id]])
       @saude = Saude.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_id]])
       @socioeconomico = Socioeconomico.find(:all,:conditions =>['aluno_id = ?', params[:aluno_aluno_id]])
        @matriculas = Matricula.find(:all, :conditions => ['aluno_id =?', params[:aluno_aluno_id]])
        @aluno.each do |aluno|

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






def consulta_cadastro_aluno
  
      session[:aluno_id]=params[:aluno][:aluno_id]

      #@socioeconomico = Socioeconomico.find(:all,:conditions => ["aluno_id = ?", params[:aluno][:aluno_id]])
      #@saude = Saude.find(:all,:conditions => ["aluno_id = ?", params[:aluno][:aluno_id]])
      @aluno = Aluno.find(:all, :select=> "aluno_nome, aluno_nascimento, aluno_RG, aluno_mae, id ", :conditions => ['id =? ', params[:aluno][:aluno_id]])
      @matriculas = Matricula.find(:all,:conditions => ['aluno_id =?', params[:aluno][:aluno_id]])
      @matriculas_ano_atual = Matricula.find(:all, :select =>"unidade_id, classe_id, ano_letivo", :conditions => ['aluno_id =? and ano_letivo=?', params[:aluno][:aluno_id], Time.now.year])
           render :update do |page|
             page.replace_html 'cadastro', :partial => 'exibe_cadastro'
            end
end


  



#  def load_alunos
#       @alunos_matriculas = Matricula.find(:all,:select => "aluno_id", :conditions => ['ano_letivo=?', Time.now.year])
#       @alunos_todos =  Aluno.find(:all,  :conditions => ['(aluno_status != "EGRESSO" or aluno_status is null) and (alunos.id NOT IN (?))', @alunos_matriculas ],:order => "aluno_nome")
     #  @alunos_todos = Aluno.find_by_sql("SELECT a.id, a.aluno_nome FROM alunos a WHERE ( aluno_status != 'EGRESSO' or aluno_status is null) AND ( id NOT IN (SELECT m.aluno_id FROM matriculas m WHERE m.ano_letivo = "+(Time.now.year).to_s+"))")


 #     @alunos1 = Aluno.find_by_sql("SELECT * FROM alunos  WHERE unidade_id= "+(current_user.unidade_id).to_s+" AND`id` NOT IN
   #                    (SELECT matriculas.aluno_id FROM matriculas INNER JOIN alunos ON alunos.id = matriculas.aluno_id WHERE matriculas.ano_letivo = "+(Time.now.year).to_s+" AND matriculas.status <> 'TRANSFERIDO' AND alunos.unidade_id = "+(current_user.unidade_id).to_s+") AND aluno_status  is null
   #                     ORDER BY aluno_nome ASC") %>

  #
    
    #t=0
    #if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then

        #@alunos =  Aluno.find(:all,:order => "aluno_nome")
        #@alunosRA =  Aluno.find(:all,:order => "aluno_ra")
        #@alunosRM =  Aluno.find(:all,:order => "aluno_rm")
        #if current_user.has_role?('admin')
        #    @alunos1 = Aluno.find(:all,:order => 'aluno_nome ASC' )
        #else
        #    @alunos1 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
       # end
        #@disciplinas = Disciplina.find(:all, :order => 'ordem ASC')
    #else

        #@alunos =  Aluno.find(:all, :conditions=> ['unidade_id = ? AND aluno_status is null', current_user.unidade_id],:order => "aluno_nome")
        #@alunosRA =  Aluno.find(:all, :conditions=> ['unidade_id = ? AND aluno_status is null', current_user.unidade_id],:order => "aluno_ra")
        #@alunosRM =  Aluno.find(:all, :conditions=> ['unidade_id = ? AND aluno_status is null', current_user.unidade_id],:order => "aluno_rm")
        #if current_user.has_role?('admin')
        #    @alunos1 = Aluno.find(:all,:order => 'aluno_nome ASC' )
        #else
        #    @alunos1 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
        #end
        #@disciplinas = Disciplina.find(:all, :order => 'ordem ASC')

       
    #end
#  end


end
