class ConteudoprogramaticosController < ApplicationController
  # GET /conteudoprogramaticos
  # GET /conteudoprogramaticos.xml

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
    w=session[:professor_id]=params[:conteudoprogramatico_professor_id]
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


def disciplina
 session[:cont_disciplina_id] =  params[:disciplina_id]
 @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and id =?", session[:professor_id], Time.now.year, params[:disciplina_id] ])
 session[:cont_classe_id]= @atribuicao[0].classe_id
 session[:cont_atribuicao_id]=@atribuicao[0].id
 session[:cont_disciplina_id]=@atribuicao[0].disciplina_id
    render :partial => 'dados_classe'
end



  def index
    @conteudoprogramaticos = Conteudoprogramatico.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conteudoprogramaticos }
    end
  end

  # GET /conteudoprogramaticos/1
  # GET /conteudoprogramaticos/1.xml
  def show
    @conteudoprogramatico = Conteudoprogramatico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conteudoprogramatico }
    end
  end

  # GET /conteudoprogramaticos/new
  # GET /conteudoprogramaticos/new.xml
  def new
    @conteudoprogramatico = Conteudoprogramatico.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conteudoprogramatico }
    end
  end

  # GET /conteudoprogramaticos/1/edit
  def edit
    @conteudoprogramatico = Conteudoprogramatico.find(params[:id])
  end

  # POST /conteudoprogramaticos
  # POST /conteudoprogramaticos.xml
  def create
    @conteudoprogramatico = Conteudoprogramatico.new(params[:conteudoprogramatico])
    if ( current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental') )
         @conteudoprogramatico.disciplina_id= session[:cont_disciplina_id]
         if ( current_user.has_role?('professor_infantil') and current_user.unidade_id != 60)
           @conteudo.disciplina_id=115
         end
    end
    @conteudoprogramatico.classe_id= session[:cont_classe_id]
    @conteudoprogramatico.atribuicao_id= session[:cont_atribuicao_id]
    @conteudoprogramatico.ano_letivo =  Time.now.year
    @conteudoprogramatico.unidade_id =  current_user.unidade_id
    @conteudoprogramatico.user_id =  current_user.id
    @conteudoprogramatico.fim=@conteudoprogramatico.inicio
    respond_to do |format|
      if @conteudoprogramatico.save
        session[:new_id]=@conteudoprogramatico.id
        flash[:notice] = 'Salvo com sucesso.'
               format.html { redirect_to(@conteudoprogramatico) }
               format.xml  { render :xml => @conteudoprogramatico, :status => :created, :location => @conteudoprogramatico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conteudoprogramatico.errors, :status => :unprocessable_entity }
      end
    end
  
  end

  # PUT /conteudoprogramaticos/1
  # PUT /conteudoprogramaticos/1.xml
  def update
    @conteudoprogramatico = Conteudoprogramatico.find(params[:id])

    respond_to do |format|
      if @conteudoprogramatico.update_attributes(params[:conteudoprogramatico])
        flash[:notice] = 'Conteudoprogramatico was successfully updated.'
        format.html { redirect_to(@conteudoprogramatico) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conteudoprogramatico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conteudoprogramaticos/1
  # DELETE /conteudoprogramaticos/1.xml
  def destroy
    @conteudoprogramatico = Conteudoprogramatico.find(params[:id])
    @conteudoprogramatico.destroy

    respond_to do |format|
      format.html { redirect_to(conteudoprogramaticos_url) }
      format.xml  { head :ok }
    end
  end


def consulta_conteudoprogramatico
  t=0
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
        t=0
        w1=session[:cons_data]=1
        w=session[:tiporelatorio]=1
        #w1=session[:professor_id]=params[:conteudo][:professor_id]
        w2=session[:dia_final]=params[:diaF]
        w3=session[:mesF]=params[:mesF]
        w4=session[:Ix]=params[:conteudoprogramatico][:inicioP1]
        w5=session[:dataI]=params[:conteudoprogramatico][:inicioP1][6,4]+'-'+params[:conteudoprogramatico][:inicioP1][3,2]+'-'+params[:conteudoprogramatico][:inicioP1][0,2]
        w6=session[:dataF]=params[:conteudoprogramatico][:fimP1][6,4]+'-'+params[:conteudoprogramatico][:fimP1][3,2]+'-'+params[:conteudoprogramatico][:fimP1][0,2]
        w7=session[:mes]=params[:conteudoprogramatico][:fimP1][3,2]
        w8=session[:anoI]=params[:conteudoprogramatico][:inicioP1][6,4]
        w9=session[:anoF]=params[:conteudoprogramatico][:fimP1][6,4]

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



end