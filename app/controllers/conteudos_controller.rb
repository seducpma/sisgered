class ConteudosController < ApplicationController
  # GET /conteudos
  # GET /conteudos.xml
     before_filter :load_dados_iniciais
   def load_dados_iniciais
     session[:cont_usuario_user_id]= current_user.unidade_id
     session[:cont_professor_user_id]= current_user.professor_id
       if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao')or current_user.has_role?('pedagogo')
         if current_user.has_role?('pedagogo')
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO"  )'],:order => 'nome ASC')
         else
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND ( classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
         end
            @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
            @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
            @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 2 or tipo_id = 3 or tipo_id = 4 or  tipo_id = 5  or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
         
       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
             @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ?' , Time.now.year,current_user.professor_id ], :order => 'classes.classe_classe ASC')
             @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 2 or  tipo_id = 5  or tipo_id = 8)'  ], :order => 'nome ASC')
              else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil') or    current_user.has_role?('pedagogo')
                  @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ', :conditions => ['desligado = 0 AND (funcao2="PEDAGOGO" OR funcao2="PROF. COORDENADOR" or funcao2="DIRETOR ED. BÁSICA"  or funcao2="DIRETOR INFANTIL")'],:order => 'nome ASC')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                   @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ? AND unidades.id = ?' , Time.now.year,current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                   @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 2 or  tipo_id = 5  or tipo_id = 8) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
                   else if current_user.has_role?('professor_fundamental')
                         @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
                         @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ? and classes.unidade_id = ?' , Time.now.year,current_user.professor_id, current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                         @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                         @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4  or tipo_id = 7) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
                         else if  current_user.has_role?('direcao_fundamental')   or    current_user.has_role?('secretaria_fundamental') or    current_user.has_role?('pedagogo')
                               @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ', :joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO" OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
                               
                               @professor_unidade = Professor.find(:all, :conditions => ['(unidade_id = ?) OR 	diversas_unidades = 1 AND desligado = 0 ', (current_user.unidade_id)],:order => 'nome ASC')
                                @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ? AND unidades.id = ?' , Time.now.year,current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                                @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                              end

                          end
                    end
              end
       end
  end

def classe
    session[:professor_id]=params[:conteudo_professor_id]

    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
    
    
    if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
       if @atribuicao.count > 1
          session[:atribuicao]=@atribuicao[0].classe_id
           render :partial => 'disciplina'
       else
           session[:cont_atribuicao_id]=@atribuicao[0].id
           session[:cont_classe_id]= @atribuicao[0].classe_id
           render :partial => 'dados_classe'
       end
    end
  end


def atividade_direcao
      session[:professor_id] = params[:conteudo_professor_id]
    @professor = Professor.find(:all, :conditions => ["id = ? AND desligado = 0", session[:professor_id]])
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
           session[:cont_atribuicao_id]=@atribuicao[0].id
           session[:cont_classe_id]= @atribuicao[0].classe_id

    if @professor.empty? or @professor.nil?
      render :partial => 'aviso2'
    else
            render :partial => 'atividade_direcao'
     end
end

def disciplina
 session[:cont_disciplina_id] =  params[:disciplina_id]
 @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and id =?", session[:professor_id], Time.now.year, params[:disciplina_id] ])
 session[:cont_classe_id]= @atribuicao[0].classe_id
 session[:cont_atribuicao_id]=@atribuicao[0].id
 session[:cont_disciplina_id]=@atribuicao[0].disciplina_id

        render :partial => 'dados_classe'
end

  def index
    @conteudos = Conteudo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conteudos }
    end
  end

  # GET /conteudos/1
  # GET /conteudos/1.xml
  def show
    @conteudo = Conteudo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end


   def show_direcao
     @conteudo = Conteudo.find(session[:new_id])
  end

 def show_mqa
     @conteudo = Conteudo.find(session[:new_id])
  end
  # GET /conteudos/new
  # GET /conteudos/new.xml
  def new
    @conteudo = Conteudo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end

 def new_direcao
    @conteudo = Conteudo.new
    session[:new_direcao]=1
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end

  def new_mqa
    @conteudo = Conteudo.new
    session[:new_mqa]=1
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end


  # GET /conteudos/1/edit
  def edit
    @conteudo = Conteudo.find(params[:id])
    session[:exclusao_id]= params[:id]
  end

  def edit_direcao
    @conteudo = Conteudo.find(params[:id])
    session[:exclusao_id]= params[:id]
  end

    def validar
    @conteudo = Conteudo.find(params[:id])
    w=session[:exclusao_id]= params[:id]
    t=0
  end



  def editar
  end


  # POST /conteudos
  # POST /conteudos.xml
  def create
    @conteudo = Conteudo.new(params[:conteudo])
    if ( current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental') ) 
         @conteudo.disciplina_id= session[:cont_disciplina_id]
         if ( current_user.has_role?('professor_infantil') and current_user.unidade_id != 60)
           @conteudo.disciplina_id=115
         end
    end
    @conteudo.classe_id= session[:cont_classe_id]
    @conteudo.atribuicao_id= session[:cont_atribuicao_id]
    @conteudo.ano_letivo =  Time.now.year
    @conteudo.unidade_id =  current_user.unidade_id
    @conteudo.user_id =  current_user.id
    respond_to do |format|
      if @conteudo.save
        session[:new_id]=@conteudo.id
        flash[:notice] = 'Salvo com sucesso.'
        if session[:new_direcao]==1
           session[:new_direcao]=0
           format.html { redirect_to(show_direcao_path) }
        else if session[:new_mqa]=1
               session[:new_mqa]=0
               format.html { redirect_to(show_mqa_path) }
               format.xml  { render :xml => @conteudo, :status => :created, :location => @conteudo }
             else
               format.html { redirect_to(@conteudo) }
               format.xml  { render :xml => @conteudo, :status => :created, :location => @conteudo }

             end
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conteudo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conteudos/1
  # PUT /conteudos/1.xml
  def update
    @conteudo = Conteudo.find(params[:id])
t=0
    respond_to do |format|
      if @conteudo.update_attributes(params[:conteudo])
        if @conteudo.validacao == 1
          @conteudo.validado_por = current_user.login
          @conteudo.validado_em = Time.now
          @conteudo.save
        end

        flash[:notice] = 'Relatório de COnteúdo lançado com sucesso.'
        format.html { redirect_to(@conteudo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conteudo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conteudos/1
  # DELETE /conteudos/1.xml
  def destroy
    @conteudo = Conteudo.find(params[:id])
    @conteudo.destroy

    respond_to do |format|
      format.html { redirect_to(home_path) }
      format.xml  { head :ok }
    end
  end


    def classe_disciplina
       params[:classe_id]
       @disciplina_classe = Disciplina.find(:all,:joins=> "INNER JOIN atribuicaos ON disciplinas.id = atribuicaos.disciplina_id", :conditions=> ['atribuicaos.classe_id =?', params[:classe_id]])
   render :partial => 'disciplina_classe'
  end


    def atuacao
         session[:atuacao]=params[:atuacao]
    end

   def atuacao_ed
       session[:atuacao]=params[:atuacao]
        end

  def mqa
    params[:conteudo_professor_id]
       @professors = Professor.find(:all, :select => 'id, nome, unidade_id, obs', :conditions=> ['id =?', params[:conteudo_professor_id]])
   render :partial => 'mqa_profissional'
  end


  def consulta_conteudo
    if params[:type_of].to_i == 3
            session[:cons_data]=0
             session[:cont_professor] =  params[:professor]
            if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
            else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                     x1=current_user.unidade_id
                    x2=current_user.professor_id
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                 else
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                     end
            end
            render :update do |page|
                page.replace_html 'relatorio', :partial => 'conteudo'
            end

    else if params[:type_of].to_i == 1   #data
        session[:cons_data]=1
        w=session[:tiporelatorio]=1
        #w1=session[:professor_id]=params[:conteudo][:professor_id]
        session[:dia_final]=params[:diaF]
        session[:mesF]=params[:mesF]
        w=session[:Ix]=params[:conteudo][:inicio]
        session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
        session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
        session[:mes]=params[:conteudo][:fim][3,2]
        session[:anoI]=params[:conteudo][:inicio][6,4]
        session[:anoF]=params[:conteudo][:fim][6,4]
       if session[:mes] == '01'
            session[:mes] = 'JANEIRO'
        else if session[:mes] == '02'
                session[:mes] = 'FEVEREIRO'
            else if session[:mes] == '03'
                    session[:mes] = 'MARÇO'
                else if session[:mes] == '04'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '05'
                            session[:mes] = 'MAIO'
                        else if session[:mes] == '06'
                                session[:mes] = 'JUNHO'
                            else if session[:mes] == '07'
                                    session[:mes] = 'JULHO'
                                else if session[:mes] == '08'
                                        session[:mes] = 'AGOSTO'
                                    else if session[:mes] == '09'
                                            session[:mes] = 'SETEMBRO'
                                        else if session[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if session[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if session[:mes] == '12'
                                                        session[:mes] = 'DEZEMBRO'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        t=0

        #ATENÇÂO COM A DATA FINAL   VVVVVVVVVVVVV

        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
            #@conteudos = Conteudo.find(:all, :conditions =>  ["inicio >=? AND (fim <=?)   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :order => 'inicio DESC, classe_id ASC')
            @conteudos = Conteudo.find(:all,:joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND (fim <=?) ", session[:dataI], session[:dataF]],  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
            @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
            @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=?   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                current_user.unidade_id
                current_user.professor_id
                #@dataF = Conteudo.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND  (fim >=?  or fim <?) AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF],current_user.professor_id, Time.now.year] , :order => 'classe_id ASC')
                #session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                #session[:dataFF]=@dataF.fim
                 #if session[:dataFF] < session[:dataF].to_date
                  #   @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND  (fim >=?  or fim <?) AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF],current_user.professor_id, Time.now.year] , :order => 'classe_id ASC')
                 #else
                    #@conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND  fim <=? AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year] , :order => 'inicio DESC, classe_id ASC')
                    @conteudos = Conteudo.find(:all, :joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND  fim <=? AND professor_id = ? AND disciplina_id IS NOT NULL ", session[:dataI], session[:dataF],current_user.professor_id] ,  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
                 #end
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

             else
                  @dataF = Conteudo.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND (fim >=?  or fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
                  session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
       #           session[:dataFF]=@dataF.fim
       #            if session[:dataFF] < session[:dataF].to_date
       #                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND (fim >=?  or fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
       #            else
                    #@conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND fim <? AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'inicio DESC, classe_id ASC')
                    @conteudos = Conteudo.find(:all, :joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND fim <? AND classes.unidade_id = ?   ", session[:dataI], session[:dataF], current_user.unidade_id] ,  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )

        #           end
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND conteudos.unidade_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND conteudos.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             end
        end
        render :update do |page|
            page.replace_html 'relatorio', :partial => 'conteudo'
        end
        else  if params[:type_of].to_i == 2
                        session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]
t=0
                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos = Conteudo.find(:all, :joins =>:classe,  :conditions =>  ["classes.unidade_id = ? and classes.classe_ano_letivo =?", session[:cont_unidade_id], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ? and  classes.classe_ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ?", session[:cont_unidade_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                               w1=current_user.unidade_id
                                w2=current_user.professor_id
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             else
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             end
                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'conteudo'
                        end
              else if params[:type_of].to_i == 4    #classe
                       session[:disciplina_id]=params[:disciplina_id]
                        session[:cons_data]=0
                        session[:cont_classe_id]=params[:classe_id]
                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
                        t=session[:disciplina_id]
                        w=0
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            if session[:disciplina_id]=='--Todas--'
                              @conteudos = Conteudo.find(:all, :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :order => 'inicio DESC, classe_id ASC')
                              @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                              @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                            else
                              @conteudos = Conteudo.find(:all, :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :order => 'inicio DESC, classe_id ASC')
                              @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta, disciplina_id ",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                              @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id],  current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                            end
                        else if (current_user.has_role?('professor_infantil')  or current_user.has_role?('direcao_infantil'))
                                w1=current_user.unidade_id
                                w2=current_user.professor_id
                              
                                if session[:disciplina_id]=='--Todas--'
                                  @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                  @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )

                                else
                                       w1=session[:cont_classe_id]
                                       w2= session[:disciplina_id]
                                       w3= current_user.professor_id
                                   if current_user.has_role?('professor_infantil')
                                        @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id],  current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                                   else  
                                        @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_professor = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_classe = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')

                                   
                                   end

t=0
                                end

                            else if ( current_user.has_role?('professor_fundamental') or current_user.has_role?('direcao_fundamental')  )
                                w1=current_user.unidade_id
                                w2=current_user.professor_id
                                if session[:disciplina_id]=='--Todas--'
                                      @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=?  AND professor_id=?", session[:cont_classe_id], session[:disciplina_id],current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                      @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                      t=0
                                 else if current_user.has_role?('professor_fundamental')
                                        if current_user.unidade_id == 1   # professor da tempo de viver
                                           w1= session[:cont_classe_id]
                                           w3= current_user.professor_id
                                          @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?  AND professor_id=?", session[:cont_classe_id],  current_user.professor_id] , :order => 'classe_id ASC')
                                          @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                          @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                                        else
                                           w1= session[:cont_classe_id]
                                           w2=session[:disciplina_id]
                                           w3= current_user.professor_id
                                          @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=? AND professor_id=?", session[:cont_classe_id],session[:disciplina_id],  current_user.professor_id] , :order => 'classe_id ASC')
                                          @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                          @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                                          t=0
                                      end
                                       else
                                        @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=?", session[:cont_classe_id],session[:disciplina_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
t=0
                                      end
                                end

                             end

                         end
                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'conteudo'
                        end


                      end
             end
        end
    end

end

  def editar_conteudo

    w=session[:disc1] =  params[:disciplina_id]
    t=0
    if params[:type_of].to_i == 3  #======??????
             session[:cons_data]=0
             session[:cont_professor] =  params[:professor]
            #session[:aluno_imp]= params[:aluno_fapea]
            #session[:ano_imp]=params[:ano_letivo]
            #session[:impressao]= 1
            #session[:tipo]=0
            if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
            else  if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))

                     x1=current_user.unidade_id
                    x2=current_user.professor_id
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                    t=0
                 else
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                    t=0
                     end
            end
            t=0
            render :update do |page|
                page.replace_html 'relatorio', :partial => 'edicao'
            end

    else if params[:type_of].to_i == 1
       
        else  if params[:type_of].to_i == 2
                         session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]
                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos = Conteudo.find(:all, :joins =>:classe,  :conditions =>  ["classes.unidade_id = ? and classes.classe_ano_letivo =?", session[:cont_unidade_id], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ? and  classes.classe_ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ?", session[:cont_unidade_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                               w1=current_user.unidade_id
                                w2=current_user.professor_id
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             else
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             end
                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'edicao'
                        end
              else if params[:type_of].to_i == 4    #CLASSE
                      session[:cons_data]=0
                        w=session[:cont_classe_id]=params[:classe_id]
                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos = Conteudo.find(:all, :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :order => 'inicio DESC, classe_id DESC')
                            @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome DESC' )
                            @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe DESC' )
                            t=0
                        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                               w1=current_user.unidade_id
                                w2=current_user.professor_id
                                #@conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? and professor_id=?", session[:cont_classe_id],current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                w=session[:disc1]
                                w1=session[:cont_classe_id]
                                if current_user.has_role?('professor_fundamental')
                                   @conteudos = Conteudo.find_by_sql("SELECT * FROM conteudos WHERE (day(created_at) = "+(Time.now.day).to_s+" AND month(created_at) = "+(Time.now.month).to_s+" AND year(created_at)="+(Time.now.year).to_s+" AND classe_id="+session[:cont_classe_id].to_s+" AND disciplina_id="+session[:disc1].to_s+" ) ORDER BY classe_id")
                                else
                                   w=session[:disc1]
                                w1=session[:cont_classe_id]
                                     @conteudos = Conteudo.find_by_sql("SELECT * FROM conteudos WHERE (day(created_at) = "+(Time.now.day).to_s+" AND month(created_at) = "+(Time.now.month).to_s+" AND year(created_at)="+(Time.now.year).to_s+" AND classe_id="+session[:cont_classe_id].to_s+" ) ORDER BY classe_id")
                                     @conteudos1= Conteudo.find(:all,:joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND (fim <=?) ", session[:dataI], session[:dataF]],  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
                                     t-0
                                end

                #  ^^  para limitar edição até final do dia  PROFESSORES

                                
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome DESC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe DESC' )
                             else
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome DESC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe DESC' )
                             end
                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'edicao'
                        end


                      end
             end
        end
    end
  end

  def consulta_direcao_conteudo
    if params[:type_of].to_i == 3
            session[:cons_data]=0
             session[:cont_professor] =  params[:professor]
            #session[:aluno_imp]= params[:aluno_fapea]
            #session[:ano_imp]=params[:ano_letivo]
            #session[:impressao]= 1
            #session[:tipo]=0
            if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
            else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                     x1=current_user.unidade_id
                    x2=current_user.professor_id
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                 else
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                     end
            end
            t=0
            render :update do |page|
                page.replace_html 'relatorio', :partial => 'conteudo_direcao'
            end

    else if params[:type_of].to_i == 1
        session[:cons_data]=1
        w=session[:tiporelatorio]=1
        #w1=session[:professor_id]=params[:conteudo][:professor_id]
        session[:dia_final]=params[:diaF]
        session[:mesF]=params[:mesF]
        session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
        session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
        session[:mes]=params[:conteudo][:fim][3,2]
        session[:anoI]=params[:conteudo][:inicio][6,4]
        session[:anoF]=params[:conteudo][:fim][6,4]
       if session[:mes] == '01'
            session[:mes] = 'JANEIRO'
        else if session[:mes] == '02'
                session[:mes] = 'FEVEREIRO'
            else if session[:mes] == '03'
                    session[:mes] = 'MARÇO'
                else if session[:mes] == '04'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '05'
                            session[:mes] = 'MAIO'
                        else if session[:mes] == '06'
                                session[:mes] = 'JUNHO'
                            else if session[:mes] == '07'
                                    session[:mes] = 'JULHO'
                                else if session[:mes] == '08'
                                        session[:mes] = 'AGOSTO'
                                    else if session[:mes] == '09'
                                            session[:mes] = 'SETEMBRO'
                                        else if session[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if session[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if session[:mes] == '12'
                                                        session[:mes] = 'DEZEMBRO'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        t=0

        #ATENÇÂO COM A DATA FINAL   VVVVVVVVVVVVV

        #session[:mostra_faltas_funcionario] = 1
        #session[:mostra_faltas_professor] = 1
        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
        #if (session[:verifica_unidade_id]=='52')
        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))

            @conteudos = Conteudo.find(:all, :joins =>[:atribuicao, :classe, :professor], :conditions =>  ["inicio >=? AND fim <=?  AND (classes.classe_classe = 'PEDAGOGO' or classes.classe_classe = 'SUPERVISAO' or  classes.classe_classe = 'COORDENACAO' or classes.classe_classe = 'DIRECAO FUNDAMENTAL' or classes.classe_classe = 'DIRECAO INFANTIL') AND conteudos.ano_letivo=? AND conteudos.unidade_id=? ", session[:dataI], session[:dataF],  Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC, inicio DESC ')
            @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ? AND (professors.funcao2 = 'PEDAGOGO' or professors.funcao2 = 'PROF. COORDENADOR' or professors.funcao2 = 'DIRETOR ED. BÁSICA')", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
            @conteudos_classe = Conteudo.find(:all, :joins =>[:atribuicao, :classe, :professor], :conditions =>  ["inicio >=? AND fim <=?  AND (classes.classe_classe = 'PEDAGOGO' or classes.classe_classe = 'SUPERVISAO' or  classes.classe_classe = 'COORDENACAO' or classes.classe_classe = 'DIRECAO FUNDAMENTAL' or classes.classe_classe = 'DIRECAO INFANTIL') AND conteudos.ano_letivo=? ", session[:dataI], session[:dataF],  Time.now.year], :order => 'professors.nome ASC')

        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                current_user.unidade_id
                current_user.professor_id
                #@dataF = Conteudo.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND  (fim >=?  or fim <?) AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF],current_user.professor_id, Time.now.year] , :order => 'classe_id ASC')
                #session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                #session[:dataFF]=@dataF.fim
                 #if session[:dataFF] < session[:dataF].to_date
                  #   @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND  (fim >=?  or fim <?) AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF],current_user.professor_id, Time.now.year] , :order => 'classe_id ASC')
                 #else
                 @conteudos = Conteudo.find(:all, :joins =>:professor, :conditions =>  ["inicio >=? AND  fim <=? AND professors.id = ?  AND ano_letivo = ? AND (professors.funcao2 = 'PEDAGOGO' or professors.funcao2 = 'PROF. COORDENADOR' or professors.funcao2 = 'DIRETOR ED. BÁSICA')", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year] , :order => 'inicio DESC, classe_id ASC')
                 #end
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             else
                  @dataF = Conteudo.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND (fim >=?  or fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
                  session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                  @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["(inicio >=? AND fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
                  #@conteudos = Conteudo.find(:all, :joins =>[:atribuicao, :classe, :professor], :conditions =>  ["inicio >=? AND fim <=?  AND (classes.classe_classe = 'PEDAGOGO' or classes.classe_classe = 'SUPERVISAO' or  classes.classe_classe = 'COORDENACAO' or classes.classe_classe = 'DIREÇÃO FUNDAMENTAL' or classes.classe_classe = 'DIREÇÃO INFANTIL')AND conteudos.unidade_id =? AND conteudos.ano_letivo=? ", session[:dataI], session[:dataF],  current_user.unidade_id, Time.now.year], :order => 'professors.nome ASC, inicio DESC ')
                  @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins =>[:atribuicao, :classe, :professor], :conditions =>  ["inicio >=? AND fim <=?  AND (classes.classe_classe = 'PEDAGOGO' or classes.classe_classe = 'SUPERVISAO' or  classes.classe_classe = 'COORDENACAO' or classes.classe_classe = 'DIRECAO FUNDAMENTAL' or classes.classe_classe = 'DIRECAO INFANTIL')AND conteudos.unidade_id =? AND conteudos.ano_letivo=? ", session[:dataI], session[:dataF],  current_user.unidade_id, Time.now.year], :order => 'professors.nome ASC')
                    @conteudos_classe = Conteudo.find(:all,:joins =>[:atribuicao, :classe, :professor], :conditions =>  ["inicio >=? AND fim <=?  AND (classes.classe_classe = 'PEDAGOGO' or classes.classe_classe = 'SUPERVISAO' or  classes.classe_classe = 'COORDENACAO' or classes.classe_classe = 'DIRECAO FUNDAMENTAL' or classes.classe_classe = 'DIRECAO INFANTIL')AND conteudos.unidade_id =? AND conteudos.ano_letivo=? ", session[:dataI], session[:dataF],  current_user.unidade_id, Time.now.year], :order => 'professors.nome ASC')
t=0
             end
        end
        render :update do |page|
            page.replace_html 'relatorio', :partial => 'conteudo_direcao'
        end
        else  if params[:type_of].to_i == 2
                        session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]

                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
#                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["conteudos.unidade_id = ? and  conteudos.ano_letivo=? and (classes.classe_classe='PEDAGOGO' or classes.classe_classe='SUPERVISÃO' or classes.classe_classe='DIREÇÃO FUNDAMENTAL' or classes.classe_classe='COORDENADOR' or classes.classe_classe='DIREÇÃO INFANTIL')  " , session[:cont_unidade_id], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
t=0
 #                       else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
 #                              w1=current_user.unidade_id
 #                               w2=current_user.professor_id
 #                               @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
 #                               @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
 #                               @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
 #                            else
 #                               @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
 #                               @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
 #                               @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
 #                            end
 #                       end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'conteudo_direcao'
                        end
              else if params[:type_of].to_i == 4
                        w=session[:atuacao]
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                        else
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )

                       end

                            render :update do |page|
                                page.replace_html 'relatorio', :partial => 'conteudo_direcao'
                            end


                   end
             end
        end
    end

end

  def editar_direcao_conteudo
    if params[:type_of].to_i == 3
            session[:cons_data]=0
             session[:cont_professor] =  params[:professor]
            #session[:aluno_imp]= params[:aluno_fapea]
            #session[:ano_imp]=params[:ano_letivo]
            #session[:impressao]= 1
            #session[:tipo]=0
            if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
            else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                     x1=current_user.unidade_id
                    x2=current_user.professor_id
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                 else
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                     end
            end
            render :update do |page|
                page.replace_html 'relatorio', :partial => 'edicao_direcao'
            end

    else if params[:type_of].to_i == 1

        else  if params[:type_of].to_i == 2
                        session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]

                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
#                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=? and (classes.classe_classe='PEDAGOGO' or classes.classe_classe='SUPERVISÃO' or classes.classe_classe='DIRECAO FUNDAMENTAL' or classes.classe_classe='DIRECAO INFANTIL') " , session[:cont_unidade_id], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
t=0
 #                       else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
 #                              w1=current_user.unidade_id
 #                               w2=current_user.professor_id
 #                               @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
 #                               @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
 #                               @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
 #                            else
 #                               @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
 #                               @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
 #                               @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
 #                            end
 #                       end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'edicao_direcao'
                        end
              else if params[:type_of].to_i == 4
                        w=session[:atuacao]
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                        else
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )

                       end

                            render :update do |page|
                                page.replace_html 'relatorio', :partial => 'edicao_direcao'
                            end


                   end
             end
        end
    end
  end

  def validacao_conteudo
    if params[:type_of].to_i == 3
            session[:cons_data]=0
             session[:cont_professor] =  params[:professor]
            #session[:aluno_imp]= params[:aluno_fapea]
            #session[:ano_imp]=params[:ano_letivo]
            #session[:impressao]= 1
            #session[:tipo]=0
            if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
            else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                     x1=current_user.unidade_id
                    x2=current_user.professor_id
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                 else
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                     end
            end
            render :update do |page|
                page.replace_html 'relatorio', :partial => 'validacao'
            end

    else if params[:type_of].to_i == 1

        else  if params[:type_of].to_i == 2
                        session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]

                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
#                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=? and (classes.classe_classe='PEDAGOGO' or classes.classe_classe='SUPERVISÃO' or classes.classe_classe='DIRECAO FUNDAMENTAL' or classes.classe_classe='DIRECAO INFANTIL') " , session[:cont_unidade_id], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
t=0
 #                       else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
 #                              w1=current_user.unidade_id
 #                               w2=current_user.professor_id
 #                               @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
 #                               @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
 #                               @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
 #                            else
 #                               @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
 #                               @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
 #                               @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
 #                            end
 #                       end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'validacao'
                        end
              else if params[:type_of].to_i == 4
                        w=session[:atuacao]
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                        else
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )

                       end

                            render :update do |page|
                                page.replace_html 'relatorio', :partial => 'validacao'
                            end


                   end
             end
        end
    end
  end

  def consulta_mqa_conteudo
    if params[:type_of].to_i == 3
            session[:cons_data]=0
             session[:cont_professor] =  params[:professor_mqa]

                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ? AND conteudos.unidade_id = 60", session[:cont_professor], Time.now.year], :order => 'inicio DESC, created_at ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ?  AND conteudos.unidade_id = 60",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.id, count( conteudos.id ) as conta", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'conteudos.obs ASC' )

            render :update do |page|
                page.replace_html 'relatorio', :partial => 'conteudo.mqa'
            end

    else if params[:type_of].to_i == 1
        session[:cons_data]=1
        w=session[:tiporelatorio]=1
        #w1=session[:professor_id]=params[:conteudo][:professor_id]
        session[:dia_final]=params[:diaF]
        session[:mesF]=params[:mesF]
        session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
        session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
        session[:mes]=params[:conteudo][:fim][3,2]
        session[:anoI]=params[:conteudo][:inicio][6,4]
        session[:anoF]=params[:conteudo][:fim][6,4]
       if session[:mes] == '01'
            session[:mes] = 'JANEIRO'
        else if session[:mes] == '02'
                session[:mes] = 'FEVEREIRO'
            else if session[:mes] == '03'
                    session[:mes] = 'MARÇO'
                else if session[:mes] == '04'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '05'
                            session[:mes] = 'MAIO'
                        else if session[:mes] == '06'
                                session[:mes] = 'JUNHO'
                            else if session[:mes] == '07'
                                    session[:mes] = 'JULHO'
                                else if session[:mes] == '08'
                                        session[:mes] = 'AGOSTO'
                                    else if session[:mes] == '09'
                                            session[:mes] = 'SETEMBRO'
                                        else if session[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if session[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if session[:mes] == '12'
                                                        session[:mes] = 'DEZEMBRO'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))

           #@conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ? AND conteudos.unidade_id = 60", session[:cont_professor], Time.now.year], :order => 'created_at ASC')
           @conteudos = Conteudo.find(:all, :joins =>[:professor], :conditions =>  ["inicio >=? AND fim <=?   AND conteudos.ano_letivo = ? AND conteudos.unidade_id = 60", session[:dataI], session[:dataF], Time.now.year], :order => 'professors.nome ASC, inicio DESC ')
           @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?    AND ano_letivo = ?  AND conteudos.unidade_id = 60",  session[:dataI], session[:dataF],Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
           @conteudos_classe = Conteudo.find(:all, :select => "conteudos.id, count( conteudos.id ) as conta", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ?",  session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'conteudos.obs ASC' )
        else
           @conteudos = Conteudo.find(:all, :joins =>[:professor], :conditions =>  ["inicio >=? AND fim <=?  AND professor_id =?  AND conteudos.ano_letivo = ? AND conteudos.unidade_id = 60", session[:dataI], session[:dataF],  session[:cont_professor], Time.now.year], :order => 'professors.nome ASC,inicio DESC ')
          @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ?  AND conteudos.unidade_id = 60",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
        end
        render :update do |page|
            page.replace_html 'relatorio',:partial => 'conteudo.mqa'
        end
        else  if params[:type_of].to_i == 2
                        session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]

                        if session[:mes] == '01'
                            session[:mes] = 'JANEIRO'
                        else if session[:mes] == '02'
                                session[:mes] = 'FEVEREIRO'
                            else if session[:mes] == '03'
                                    session[:mes] = 'MARÇO'
                                else if session[:mes] == '04'
                                        session[:mes] = 'ABRIL'
                                    else if params[:mes] == '05'
                                            session[:mes] = 'MAIO'
                                        else if session[:mes] == '06'
                                                session[:mes] = 'JUNHO'
                                            else if session[:mes] == '07'
                                                    session[:mes] = 'JULHO'
                                                else if session[:mes] == '08'
                                                        session[:mes] = 'AGOSTO'
                                                    else if session[:mes] == '09'
                                                            session[:mes] = 'SETEMBRO'
                                                        else if session[:mes] == '10'
                                                                session[:mes] = 'OUTUBRO'
                                                            else if session[:mes] == '11'
                                                                    session[:mes] = 'NOVEMBRO'
                                                                else if session[:mes] == '12'
                                                                        session[:mes] = 'DEZEMBRO'
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        t=0
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=? and (classes.classe_classe='PEDAGOGO' or classes.classe_classe='SUPERVISÃO' or classes.classe_classe='DIRECAO FUNDAMENTAL' or classes.classe_classe='DIRECAO INFANTIL') " , session[:cont_unidade_id], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["professors.unidade_id = ? and  conteudos.ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'conteudo_direcao'
                        end
              else if params[:type_of].to_i == 4
                        w=session[:atuacao]
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta",:conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?", session[:atuacao], Time.now.year], :group => 'conteudos.professor_id', :order => 'professors.nome ASC' )
                        else
                            @conteudos= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC, inicio DESC ' )
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:classe, :professor], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )
                            @conteudos_classe= Conteudo.find(:all, :joins =>[:classe, :professor], :conditions =>  ["classes.classe_classe = ? and  conteudos.ano_letivo=?  AND conteudos.unidade_id=?", session[:atuacao], Time.now.year, current_user.unidade_id], :order => 'professors.nome ASC' )

                       end

                            render :update do |page|
                                page.replace_html 'relatorio', :partial => 'conteudo_direcao'
                            end


                   end
             end
        end
    end

end

def editar_mqa_conteudo
    if params[:type_of].to_i == 3
            session[:cons_data]=0
             session[:cont_professor] =  params[:professor_mqa]

                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ? AND conteudos.unidade_id = 60", session[:cont_professor], Time.now.year], :order => 'inicio DESC, created_at ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ?  AND conteudos.unidade_id = 60",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.id, count( conteudos.id ) as conta", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'conteudos.obs ASC' )

            render :update do |page|
                page.replace_html 'relatorio', :partial => 'edicao_mqa'
            end

    else if params[:type_of].to_i == 1
        session[:cons_data]=1
        w=session[:tiporelatorio]=1
        #w1=session[:professor_id]=params[:conteudo][:professor_id]
        session[:dia_final]=params[:diaF]
        session[:mesF]=params[:mesF]
        session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
        session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
        session[:mes]=params[:conteudo][:fim][3,2]
        session[:anoI]=params[:conteudo][:inicio][6,4]
        session[:anoF]=params[:conteudo][:fim][6,4]
       if session[:mes] == '01'
            session[:mes] = 'JANEIRO'
        else if session[:mes] == '02'
                session[:mes] = 'FEVEREIRO'
            else if session[:mes] == '03'
                    session[:mes] = 'MARÇO'
                else if session[:mes] == '04'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '05'
                            session[:mes] = 'MAIO'
                        else if session[:mes] == '06'
                                session[:mes] = 'JUNHO'
                            else if session[:mes] == '07'
                                    session[:mes] = 'JULHO'
                                else if session[:mes] == '08'
                                        session[:mes] = 'AGOSTO'
                                    else if session[:mes] == '09'
                                            session[:mes] = 'SETEMBRO'
                                        else if session[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if session[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if session[:mes] == '12'
                                                        session[:mes] = 'DEZEMBRO'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))

           #@conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ? AND conteudos.unidade_id = 60", session[:cont_professor], Time.now.year], :order => 'created_at ASC')
           @conteudos = Conteudo.find(:all, :joins =>[:professor], :conditions =>  ["inicio >=? AND fim <=?   AND conteudos.ano_letivo = ? AND conteudos.unidade_id = 60", session[:dataI], session[:dataF], Time.now.year], :order => 'professors.nome ASC, inicio DESC ')
           @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?    AND ano_letivo = ?  AND conteudos.unidade_id = 60",  session[:dataI], session[:dataF],Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
           @conteudos_classe = Conteudo.find(:all, :select => "conteudos.id, count( conteudos.id ) as conta", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ?",  session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'conteudos.obs ASC' )
        else
           @conteudos = Conteudo.find(:all, :joins =>[:professor], :conditions =>  ["inicio >=? AND fim <=?  AND professor_id =?  AND conteudos.ano_letivo = ? AND conteudos.unidade_id = 60", session[:dataI], session[:dataF],  session[:cont_professor], Time.now.year], :order => 'professors.nome ASC, inicio DESC ')
          @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ?  AND conteudos.unidade_id = 60",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
        end
        render :update do |page|
            page.replace_html 'relatorio',:partial => 'edicao_mqa'
        end
        else  if params[:type_of].to_i == 2
              else if params[:type_of].to_i == 4
                    
                   end
             end
        end
    end

end


end
