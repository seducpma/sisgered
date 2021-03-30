class AtividadesController < ApplicationController
    # GET /atividades
    # GET /atividades.xml

    before_filter :load_dados_iniciais

    def load_dados_iniciais

        if current_user.has_role?('direcao_fundamental') or current_user.has_role?('professor_fundamental')
               @Avaliacao = [nil,"10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0", "NE","EB","EF","EN"]
           else if current_user.has_role?('direcao_infantil') or current_user.has_role?('professor_infantil')
                  @Avaliacao = [nil,"NE","EB","EF","EN"]

                else
                   @Avaliacao = [nil,"10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","NE","EB","EF","EN"]
                end
        end
        
        if current_user.has_role?('admin') or current_user.has_role?('SEDUC')
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO" OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
            @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
            @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
            @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 2 or tipo_id = 3 or tipo_id = 4 or  tipo_id = 5  or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
        else if current_user.has_role?('direcao_fundamental')  or current_user.has_role?('pedagogo')or current_user.has_role?('supervisao')
                @professor_unidade = Professor.find(:all,:select => "distinct(professors.nome), professors.id", :joins => "INNER JOIN  atribuicaos   ON  professors.id = atribuicaos.professor_id INNER JOIN  classes   ON  classes.id = atribuicaos.classe_id ", :conditions => ['classes.unidade_id = ?  AND professors.desligado = 0 and atribuicaos.ano_letivo =?', current_user.unidade_id, Time.now.year],:order => 'nome ASC')
             else
                @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
                @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ? and classes.unidade_id = ?' , Time.now.year,current_user.professor_id, current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                #@unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4  or tipo_id = 7) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
             end
        end
    end


    def index
        @atividades = Atividade.all
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @atividades }
        end
    end

    # GET /atividades/1
    # GET /atividades/1.xml
    def show
        @atividade = Atividade.find(params[:id])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @atividade }
        end
    end

    # GET /atividades/new
    # GET /atividades/new.xml
    def new
        @atividade = Atividade.new
t0=0
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @atividade }
        end
    end

    # GET /atividades/1/edit
    def edit
        @atividade=Atividade.find(params[:id])
    end

    # POST /atividades
    # POST /atividades.xml
    def create
        @atividade=Atividade.new(params[:atividade])

        @atividade.classe_id= session[:ativ_classe_id]
        #@atividade.atribuicao_id= session[:ativ_atribuicao_id]
        #@atividade.disciplina_id =session[:ativ_disciplina_id]
         @atividade.atribuicao_id =session[:cont_atribuicao_id]
         @atividade.classe_id = session[:cont_classe_id]
         @atividade.disciplina_id=session[:cont_disciplina_id]
        @atividade.ano_letivo =  Time.now.year
        @atividade.unidade_id =  current_user.unidade_id
        @atividade.user_id =  current_user.id
        @atividade.fim  =  @atividade.inicio
t0=0
        respond_to do |format|
            if @atividade.save

                ## CRIA AVALIAÇÂO  por aluno x classe

                @matriculas = Matricula.find(:all,:conditions =>['classe_id = ? and (status="MATRICULADO" or status="TRANSFERENCIA" or status="*REMANEJADO")', @atividade.classe_id], :order => 'classe_num ASC')
                quantidade = @matriculas.count
t=0
                for mat in @matriculas
                    @atividade_avaliacao = AtividadeAvaliacao.new(params[:atividade_avaliacao])
                    @atividade_avaliacao.aluno_id= mat.aluno_id
                    @atividade_avaliacao.matricula_id= mat.id
                    @atividade_avaliacao.atividade_id=@atividade.id
                    @atividade_avaliacao.classe_id= @atividade.classe_id
                    @atividade_avaliacao.professor_id=  @atividade.professor_id
                    @atividade_avaliacao.atribuicao_id=   @atividade.atribuicao_id
                    @atividade_avaliacao.disciplina_id =   @atividade.disciplina_id
                    @atividade_avaliacao.ano_letivo =   @atividade.ano_letivo
                    @atividade_avaliacao.unidade_id =    @atividade.unidade_id
                    @atividade_avaliacao.user_id =    @atividade.user_id
                    @atividade_avaliacao.save
                end
t0=0
                flash[:notice] = 'Atividade salva com sucesso.'
                format.html { redirect_to(@atividade) }
                format.xml  { render :xml => @atividade, :status => :created, :location => @atividade }
            else
t0=0
                format.html { render :action => "new" }
                format.xml  { render :xml => @atividade.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /atividades/1
    # PUT /atividades/1.xml
    def update
        @atividade = Atividade.find(params[:id])

        respond_to do |format|
            @atividade.fim=@atividade.inicio
            if @atividade.update_attributes(params[:atividade])
                flash[:notice] = 'Atividade salva com sucesso.'
                format.html { redirect_to(@atividade) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @atividade.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /atividades/1
    # DELETE /atividades/1.xml
    def destroy
        @atividade = Atividade.find(params[:id])
        @atividade.destroy

        respond_to do |format|
            format.html { redirect_to(atividades_url) }
            format.xml  { head :ok }
        end
    end

    def classe
        session[:professor_id]=params[:atividade_professor_id]
        @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
        if @atribuicao.empty? or @atribuicao.nil?
            render :partial => 'aviso'
        else
            if @atribuicao.count > 1
                render :partial => 'disciplina'
            else
                session[:cont_atribuicao_id]=@atribuicao[0].id
                session[:cont_classe_id]= @atribuicao[0].classe_id
                session[:cont_disciplina_id]= @atribuicao[0].disciplina_id

                render :partial => 'dados_classe'
            end
        end
    end

    def disciplina

        session[:ativ_disciplina_id] =  params[:disciplina_id]  # <<<<<< ATENÇÂO esta escrito disciplina_id mas é atribuicao_id <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and id =?", session[:professor_id], Time.now.year, params[:disciplina_id] ])
        #session[:ativ_classe_id]= @atribuicao[0].classe_id
        #session[:ativ_atribuicao_id]=@atribuicao[0].id
        #session[:ativ_disciplina_id]=@atribuicao[0].disciplina_id
        w=session[:cont_atribuicao_id]=@atribuicao[0].id
        w1=session[:cont_classe_id]= @atribuicao[0].classe_id
        w1=session[:cont_disciplina_id]= @atribuicao[0].disciplina_id
        render :partial => 'dados_classe'
    end


    def consultaatividade

        if params[:type_of].to_i == 1
            if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ?',Time.now.year, "%" + params[:search].to_s + "%"],:order => 'inicio DESC')
            else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ? and unidade_id =?',Time.now.year, "%" + params[:search].to_s + "%", current_user.unidade_id],:order => 'inicio DESC')
               
                else
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ? and professor_id =?',Time.now.year, "%" + params[:search].to_s + "%", current_user.professor_id],:order => 'inicio DESC')
                end
            end

          
            render :update do |page|
                page.replace_html 'atividades', :partial => "atividades"
            end
        else if params[:type_of].to_i == 2
                if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=?',Time.now.year, session[:classe_id],params[:disciplina_id]],:order => 'inicio DESC')
                else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=? and unidade_id =?',Time.now.year, session[:classe_id],params[:disciplina_id], current_user.unidade_id],:order => 'inicio DESC')
                    else
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=? and professor_id =?',Time.now.year, session[:classe_id],params[:disciplina_id], current_user.professor_id],:order => 'inicio DESC')                     end
                end
                render :update do |page|
                    page.replace_html 'atividades', :partial => "atividades"
                end
            else if params[:type_of].to_i == 3
                    if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? ',Time.now.year,  params[:professor][:id]],:order => 'inicio DESC')
                    else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                            @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? and unidade_id =?',Time.now.year,  params[:professor][:id], current_user.unidade_id],:order => 'inicio DESC')

                        else
                            @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? and professor_id =?',Time.now.year,  params[:professor][:id], current_user.professor_id],:order => 'inicio DESC')
                        end
                    end

                    render :update do |page|
                        page.replace_html 'atividades', :partial => "atividades"
                    end
                else if params[:type_of].to_i == 4

                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and unidade_id=? ',Time.now.year,  params[:unidade][:id]],:order => 'inicio DESC')
                        render :update do |page|
                            page.replace_html 'atividades', :partial => "atividades"
                        end
                    else if params[:type_of].to_i == 5
                            if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                                @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? ',Time.now.year,  params[:disciplina][:id]],:order => 'inicio DESC')
                            else if  current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? and unidade_id =? ',Time.now.year,  params[:disciplina][:id], current_user.unidade_id],:order => 'inicio DESC')
                                else
                                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? and professor_id =? ',Time.now.year,  params[:disciplina][:id], current_user.professor_id],:order => 'inicio DESC')
                                end
                            end
                            render :update do |page|
                                page.replace_html 'atividades', :partial => "atividades"
                            end
                        else if params[:type_of].to_i == 6

                                session[:dia_final]=params[:diaF]
                                session[:mesF]=params[:mesF]
                                session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
                                session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                                session[:mes]=params[:conteudo][:fim][3,2]
                                session[:anoI]=params[:conteudo][:inicio][6,4]
                                session[:anoF]=params[:conteudo][:fim][6,4]

                                if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                                    @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year],  :order => 'professors.nome ASC' )
                                else if  current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                                        @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ?  and atividades.unidade_id =? ", session[:dataI], session[:dataF], Time.now.year, current_user.unidade_id ],  :order => 'professors.nome ASC' )
                                  
                                    else
                                        @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ?  and atividades.professor_id =? ", session[:dataI], session[:dataF], Time.now.year, current_user.professor_id ],  :order => 'professors.nome ASC' )
                                    end
                                end
                                #                                   @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado = 0", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
                                render :update do |page|
                                    page.replace_html 'atividades', :partial => "atividades"
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    def consultas
    end


    def avaliacao
    end

    def valiadar_atividades
        ano=Time.now.year.to_s
        mes=format("%02d", Time.now.month)
        dia_f=Date.new(Time.now.year,Time.now.month,-1).day.to_s
        if (params[:atividade][:inicio].length!=10) and (params[:atividade][:fim].length!=10) then
            session[:dataI]=ano+'-'+mes+'-01'
            session[:dataF]=ano+'-'+mes+'-'+dia_f
        else
            if (params[:atividade][:inicio].length!=10) and (params[:atividade][:fim].length==10)
                session[:dataI]=ano+'-'+mes+'-01'
                session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
            else
                if (params[:atividade][:inicio].length==10) and (params[:atividade][:fim].length!=10)
                    session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
                    session[:dataF]=ano+'-'+mes+'-'+dia_f
                else
                    session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
                    session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
                end
            end
        end

#        session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
#        session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
        session[:dataIshow]=params[:atividade][:inicio]
        session[:dataFshow]=params[:atividade][:fim]
        session[:professor]=params[:professor][:id]
        session[:classe]=params[:classe][:id]
        session[:disciplina]=params[:disciplina]
        @atividades= Atividade.find(:all, :conditions=>[ 'professor_id=? and	classe_id =?  and	disciplina_id=? and inicio>=?  and fim<=?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF]], :order => 'inicio DESC')
        t=0
        render :update do |page|
            page.replace_html 'atividades', :partial => "atividades_avaliacao"
        end
    end

    def classe_disciplina
        session[:classe_id]=params[:classe_id]
        @disciplina_classe = Disciplina.find(:all,:select => 'distinct(disciplinas.disciplina), disciplinas.id' ,:joins=> "INNER JOIN atribuicaos ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN atividades ON disciplinas.id = atividades.disciplina_id", :conditions=> ['atribuicaos.classe_id =? and atividades.classe_id=?', params[:classe_id], session[:classe_id]])
t0=0
        render :partial => 'disciplina_classe'
    end
   def classe_disciplina_periodo
        w=session[:classe_id]=params[:classe_id]
        @disciplina_classe = Disciplina.find(:all,:select => 'distinct(disciplinas.disciplina), disciplinas.id' ,:joins=> "INNER JOIN atribuicaos ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN atividades ON disciplinas.id = atividades.disciplina_id", :conditions=> ['atribuicaos.classe_id =? and atividades.classe_id=?', params[:classe_id], session[:classe_id]])
        render :partial => 'disciplina_classe_periodo'
    end

    def avaliar_atividades
        t=0
        @atividade = Atividade.find(params[:id])
        session[:atividade_show]=params[:id]
        #@atividades= Atividade.find(:all, :conditions=>[ 'professor_id=? and	classe_id =?  and	disciplina_id=? and inicio>=?  and fim<=?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF]])
        @atividade_avaliacao= AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?  and	atividade_avaliacaos.disciplina_id=?and atividades.inicio>=?  and atividades.fim<=? and atividades.id =?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF],session[:atividade_show]])
#,  :order => 'atividade_id ASC' )
t=0
        w=session[:classe_id]
        w1=session[:professor_id]
        w2=session[:disc_id]



        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
t=0
    end

    def update_multiplas_atividades
        AtividadeAvaliacao.update(params[:atividade].keys, params[:atividade].values)
        flash[:notice] = 'AVALIÇÂO ATIVIDADES.'
        @atividades= Atividade.find(:all, :conditions=>[ 'professor_id=? and	classe_id =?  and	disciplina_id=? and inicio>=?  and fim<=?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF]])
        @atividade_avaliacao= AtividadeAvaliacao.find(:all, :conditions =>  ['professor_id=? and classe_id =?  and	disciplina_id=?',  session[:professor], session[:classe] , session[:disciplina]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])

        respond_to do |format|

            flash[:notice] = 'Atividade was successfully updated.'
            format.html { redirect_to(show_atividades_path) }
            format.xml  { head :ok }

        end
    end
    

    def show_avaliacao_atividades
        @atividades= Atividade.find(:all, :conditions=>[ 'professor_id=? and	classe_id =?  and	disciplina_id=? and inicio>=?  and fim<=?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF]])
        @atividade_avaliacao_alunos= AtividadeAvaliacao.find(:all, :conditions =>  ['atividade_id =? ',  session[:atividade_show]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
    end

    def show_avaliacao

        @atividade= Atividade.find(:all, :conditions=>[ 'id =?', params[:id]])
        session[:atividade]=@atividade[0].id
        @atividade_avaliacao_alunos= AtividadeAvaliacao.find(:all, :conditions =>  ['atividade_id=? ',  params[:id]])
        #@atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
        
    end

    def avaliacao_consulta

    end

    def consultar_avaliacoes

        if params[:type_of].to_i == 1
            if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ?',Time.now.year, "%" + params[:search].to_s + "%"],:order => 'inicio DESC')
            else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ? and unidade_id =?',Time.now.year, "%" + params[:search].to_s + "%", current_user.unidade_id],:order => 'inicio DESC')

                else
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ? and professor_id =?',Time.now.year, "%" + params[:search].to_s + "%", current_user.professor_id],:order => 'inicio DESC')
                end
            end
            session[:professor]= @atividades[0].professor_id
            session[:classe=]= @atividades[0].classe_id
            session[:disciplina]= @atividades[0].disciplina_id
            render :update do |page|
                page.replace_html 'atividades', :partial => "atividades_consultas"
            end
        else if params[:type_of].to_i == 2
                if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=?',Time.now.year, session[:classe_id],params[:disciplina_id]],:order => 'inicio DESC')
                else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=? and unidade_id =?',Time.now.year, session[:classe_id],params[:disciplina_id], current_user.unidade_id],:order => 'inicio DESC')
                    else
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=? and professor_id =?',Time.now.year, session[:classe_id],params[:disciplina_id], current_user.professor_id],:order => 'inicio DESC')                     end
                end
                session[:professor]= @atividades[0].professor_id
                session[:classe=]= @atividades[0].classe_id
                session[:disciplina]= @atividades[0].disciplina_id

                render :update do |page|
                    page.replace_html 'atividades', :partial => "atividades_consultas"
                end
            else if params[:type_of].to_i == 3
                    if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? ',Time.now.year,  params[:professor][:id]],:order => 'inicio DESC')
                    else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                            @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? and unidade_id =?',Time.now.year,  params[:professor][:id], current_user.unidade_id],:order => 'inicio DESC')

                        else
                            @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? and professor_id =?',Time.now.year,  params[:professor][:id], current_user.professor_id],:order => 'inicio DESC')
                        end
                    end
                    session[:professor]= @atividades[0].professor_id
                    session[:classe=]= @atividades[0].classe_id
                    session[:disciplina]= @atividades[0].disciplina_id

                    render :update do |page|
                        page.replace_html 'atividades', :partial => "atividades_consultas"
                    end
                else if params[:type_of].to_i == 4

                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and unidade_id=? ',Time.now.year,  params[:unidade][:id]],:order => 'inicio DESC')

                        w=session[:professor]= @atividades[0].professor_id
                        w1=session[:classe=]= @atividades[0].classe_id
                        w2=session[:disciplina]= @atividades[0].disciplina_id
                        t=0
                        render :update do |page|
                            page.replace_html 'atividades', :partial => "atividades_consultas"
                        end
                    else if params[:type_of].to_i == 5
                            if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                                @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? ',Time.now.year,  params[:disciplina][:id]],:order => 'inicio DESC')
                            else if  current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? and unidade_id =? ',Time.now.year,  params[:disciplina][:id], current_user.unidade_id],:order => 'inicio DESC')
                                else
                                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? and professor_id =? ',Time.now.year,  params[:disciplina][:id], current_user.professor_id],:order => 'inicio DESC')
                                end
                            end
                            session[:professor]= @atividades[0].professor_id
                            session[:classe=]= @atividades[0].classe_id
                            session[:disciplina]= @atividades[0].disciplina_id

                            render :update do |page|
                                page.replace_html 'atividades', :partial => "atividades_consultas"
                            end
                        else if params[:type_of].to_i == 6

                                session[:dia_final]=params[:diaF]
                                session[:mesF]=params[:mesF]
                                session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
                                session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                                session[:mes]=params[:conteudo][:fim][3,2]
                                session[:anoI]=params[:conteudo][:inicio][6,4]
                                session[:anoF]=params[:conteudo][:fim][6,4]

                                if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                                    @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year],  :order => 'professors.nome ASC' )
                                else if  current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                                        @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ?  and atividades.unidade_id =? ", session[:dataI], session[:dataF], Time.now.year, current_user.unidade_id ],  :order => 'professors.nome ASC' )

                                    else
                                        @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ?  and atividades.professor_id =? ", session[:dataI], session[:dataF], Time.now.year, current_user.professor_id ],  :order => 'professors.nome ASC' )
                                    end
                                end
                                session[:professor]= @atividades[0].professor_id
                                session[:classe=]= @atividades[0].classe_id
                                session[:disciplina]= @atividades[0].disciplina_id
                                #                                   @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado = 0", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
                                render :update do |page|
                                    page.replace_html 'atividades', :partial => "atividades_consultas"
                                end
                            end
                        end
                    end

                end
            end
        end


        #===========================
        #este é o anterior

        #session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
        #session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
        #session[:professor]=params[:professor][:id]
        #session[:classe]=params[:classe][:id]
        #session[:disciplina]=params[:disciplina]
        # @atividade_avaliacao_alunos= AtividadeAvaliacao.find(:all, :conditions =>  ['atividade_id =? ',  session[:atividade_show]])
        #@atividades= Atividade.find(:all, :conditions=>[ 'professor_id=? and	classe_id =?  and	disciplina_id=? and inicio>=?  and fim<=?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF]])
        #@atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
        #t=0
        #render :update do |page|
        #   page.replace_html 'atividades', :partial => "show_avaliacao_atividades"
        #end
    end
    
    def consultar_avaliacoes_periodo

        if params[:type_of].to_i == 1
            if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ?',Time.now.year, "%" + params[:search].to_s + "%"],:order => 'inicio DESC')
                #nao programado
            else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                        ano=Time.now.year.to_s
                        mes=format("%02d", Time.now.month)
                        dia_f=Date.new(Time.now.year,Time.now.month,-1).day.to_s
                        if (params[:atividade][:inicio].length!=10) and (params[:atividade][:fim].length!=10) then
                            session[:dataI]=ano+'-'+mes+'-01'
                            session[:dataF]=ano+'-'+mes+'-'+dia_f
                        else
                            if (params[:atividade][:inicio].length!=10) and (params[:atividade][:fim].length==10)
                                session[:dataI]=ano+'-'+mes+'-01'
                                session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
                            else
                                if (params[:atividade][:inicio].length==10) and (params[:atividade][:fim].length!=10)
                                    session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
                                    session[:dataF]=ano+'-'+mes+'-'+dia_f
                                else
                                    session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
                                    session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
                                end
                            end
                        end
                        session[:dataINI]=session[:dataI][8,2]+'-'+session[:dataI][5,2]+'-'+session[:dataI][0,4]
                        session[:dataFIM]=session[:dataF][8,2]+'-'+session[:dataF][5,2]+'-'+session[:dataF][0,4]
                        #@atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ? and professor_id =?  and atividades.inicio>=? and atividades.fim<=?',Time.now.year, "%" + params[:search].to_s + "%", current_user.professor_id,session[:dataI], session[:dataF]],:order => 'inicio DESC')
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ? and unidade_id =? and atividades.inicio>=? and atividades.fim<=?',Time.now.year, "%" + params[:search].to_s + "%", current_user.unidade_id,session[:dataI], session[:dataF]],:order => 'inicio, id')
                        @atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id],:order => 'inicio, id')
                        @avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? and atividades.atividade like ?',  session[:professor], session[:classe] ,session[:dataI], session[:dataF], "%" + params[:search].to_s + "%"])

                else
                    ano=Time.now.year.to_s
                    mes=format("%02d", Time.now.month)
                    dia_f=Date.new(Time.now.year,Time.now.month,-1).day.to_s
                    if (params[:atividade][:inicio].length!=10) and (params[:atividade][:fim].length!=10) then
                        session[:dataI]=ano+'-'+mes+'-01'
                        session[:dataF]=ano+'-'+mes+'-'+dia_f
                    else
                        if (params[:atividade][:inicio].length!=10) and (params[:atividade][:fim].length==10)
                            session[:dataI]=ano+'-'+mes+'-01'
                            session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
                        else
                            if (params[:atividade][:inicio].length==10) and (params[:atividade][:fim].length!=10)
                                session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
                                session[:dataF]=ano+'-'+mes+'-'+dia_f
                            else
                                session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
                                session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
                            end
                        end
                    end
                    session[:dataINI]=session[:dataI][8,2]+'-'+session[:dataI][5,2]+'-'+session[:dataI][0,4]
                    session[:dataFIM]=session[:dataF][8,2]+'-'+session[:dataF][5,2]+'-'+session[:dataF][0,4]
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ? and professor_id =?  and atividades.inicio>=? and atividades.fim<=?',Time.now.year, "%" + params[:search].to_s + "%", current_user.professor_id,session[:dataI], session[:dataF]],:order => 'inicio, id')
                    @atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id],:order => 'inicio, id')
                    @avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? and atividades.atividade like ?',  session[:professor], session[:classe] ,session[:dataI], session[:dataF], "%" + params[:search].to_s + "%"])
                end
            end
           session[:professor]= @atividades[0].professor_id
           session[:classe=]= @atividades[0].classe_id

            render :update do |page|
                page.replace_html 'atividades_periodo', :partial => "atividades_consultas_periodo"
            end
        else if params[:type_of].to_i == 2
         w=params[:disciplina_id]
          t=0

                if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                  if params[:disciplina_id]== '--Todas--'
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? ',Time.now.year, session[:classe_id]],:order => 'inicio DESC')
                  else
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=?',Time.now.year, session[:classe_id],params[:disciplina_id]],:order => 'inicio DESC')
                  end
                else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')

                        ano=Time.now.year.to_s
                        mes=format("%02d", Time.now.month)
                        dia_f=Date.new(Time.now.year,Time.now.month,-1).day.to_s
                        if (params[:atividade][:inicio_cla].length!=10) and (params[:atividade][:fim_cla].length!=10) then
                            session[:dataI]=ano+'-'+mes+'-01'
                            session[:dataF]=ano+'-'+mes+'-'+dia_f
                        else
                            if (params[:atividade][:inicio_cla].length!=10) and (params[:atividade][:fim_cla].length==10)
                                session[:dataI]=ano+'-'+mes+'-01'
                                session[:dataF]=params[:atividade][:fim_cla][6,4]+'-'+params[:atividade][:fim_cla][3,2]+'-'+params[:atividade][:fim_cla][0,2]
                            else
                                if (params[:atividade][:inicio_cla].length==10) and (params[:atividade][:fim_cla].length!=10)
                                    session[:dataI]=params[:atividade][:inicio_cla][6,4]+'-'+params[:atividade][:inicio_cla][3,2]+'-'+params[:atividade][:inicio_cla][0,2]
                                    session[:dataF]=ano+'-'+mes+'-'+dia_f
                                else
                                    session[:dataI]=params[:atividade][:inicio_cla][6,4]+'-'+params[:atividade][:inicio_cla][3,2]+'-'+params[:atividade][:inicio_cla][0,2]
                                    session[:dataF]=params[:atividade][:fim_cla][6,4]+'-'+params[:atividade][:fim_cla][3,2]+'-'+params[:atividade][:fim_cla][0,2]
                                end
                            end
                        end
                        session[:dataINI]=session[:dataI][8,2]+'-'+session[:dataI][5,2]+'-'+session[:dataI][0,4]
                        session[:dataFIM]=session[:dataF][8,2]+'-'+session[:dataF][5,2]+'-'+session[:dataF][0,4]
                        w=session[:dataI]
                        w1= session[:dataF]
                        if params[:disciplina_id]== '--Todas--'
                              @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=? and unidade_id =? and atividades.inicio>=? and atividades.fim<=?',Time.now.year, session[:classe_id],params[:disciplina_id], current_user.unidade_id, session[:dataI], session[:dataF]],:order => 'inicio, id')
                               @atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id])
                               @avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? ',  session[:professor], session[:classe] ,session[:dataI], session[:dataF]],:order => 'inicio, id')

                         else
                             @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and unidade_id =? and atividades.inicio>=? and atividades.fim<=?',Time.now.year, session[:classe_id], current_user.unidade_id, session[:dataI], session[:dataF]],:order => 'inicio, id')
                            @atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id])
                            @avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? and atividades.disciplina_id=?',  session[:professor], session[:classe] ,session[:dataI], session[:dataF], params[:disciplina_id]],:order => 'inicio, id')

                         end
                        
                        @atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id])
                        @avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? and atividades.disciplina_id=?',  session[:professor], session[:classe] ,session[:dataI], session[:dataF], params[:disciplina_id]],:order => 'inicio, id')
                    else
                        ano=Time.now.year.to_s
                        mes=format("%02d", Time.now.month)
                        dia_f=Date.new(Time.now.year,Time.now.month,-1).day.to_s
                        if (params[:atividade][:inicio_cla].length!=10) and (params[:atividade][:fim_cla].length!=10) then
                            session[:dataI]=ano+'-'+mes+'-01'
                            session[:dataF]=ano+'-'+mes+'-'+dia_f
                        else
                            if (params[:atividade][:inicio_cla].length!=10) and (params[:atividade][:fim_cla].length==10)
                                session[:dataI]=ano+'-'+mes+'-01'
                                session[:dataF]=params[:atividade][:fim_cla][6,4]+'-'+params[:atividade][:fim_cla][3,2]+'-'+params[:atividade][:fim_cla][0,2]
                            else
                                if (params[:atividade][:inicio_cla].length==10) and (params[:atividade][:fim_cla].length!=10)
                                    session[:dataI]=params[:atividade][:inicio_cla][6,4]+'-'+params[:atividade][:inicio_cla][3,2]+'-'+params[:atividade][:inicio_cla][0,2]
                                    session[:dataF]=ano+'-'+mes+'-'+dia_f
                                else
                                    session[:dataI]=params[:atividade][:inicio_cla][6,4]+'-'+params[:atividade][:inicio_cla][3,2]+'-'+params[:atividade][:inicio_cla][0,2]
                                    session[:dataF]=params[:atividade][:fim_cla][6,4]+'-'+params[:atividade][:fim_cla][3,2]+'-'+params[:atividade][:fim_cla][0,2]
                                end
                            end
                        end
                        session[:dataINI]=session[:dataI][8,2]+'-'+session[:dataI][5,2]+'-'+session[:dataI][0,4]
                        session[:dataFIM]=session[:dataF][8,2]+'-'+session[:dataF][5,2]+'-'+session[:dataF][0,4]
                        w=session[:dataI]
                        w1= session[:dataF]
                        if params[:disciplina_id]== '--Todas--'
                             @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and professor_id =? and atividades.inicio>=? and atividades.fim<=?',Time.now.year, session[:classe_id], current_user.professor_id, session[:dataI], session[:dataF]],:order => 'inicio, id')
                             @atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id])
                             @avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? ',  session[:professor], session[:classe] ,session[:dataI], session[:dataF]],:order => 'inicio, id')
                             w=@avaliacoes[0].id
t=0

                        else
                             @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=? and professor_id =? and atividades.inicio>=? and atividades.fim<=?',Time.now.year, session[:classe_id],params[:disciplina_id], current_user.professor_id, session[:dataI], session[:dataF]],:order => 'inicio, id')
                             @atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id])
                             @avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? and atividades.disciplina_id = ?',  session[:professor], session[:classe] ,session[:dataI], session[:dataF], params[:disciplina_id]],:order => 'inicio, id')
                             t=0
                        end
                        #@atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=? and atividades.inicio>=? and atividades.fim<=?',Time.now.year, session[:classe_id],params[:disciplina_id], session[:dataI], session[:dataF]],:order => 'inicio, id')
                        #@atividades_avaliacao_alunos= AtividadeAvaliacao.find(:all,:conditions =>['atividade_id=?',@atividades[0].id])
                        #@avaliacoes=AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.classe_id =?   and atividades.inicio>=? and atividades.fim<=? and atividades.disciplina_id = ?',   session[:classe] ,session[:dataI], session[:dataF], params[:disciplina_id]],:order => 'inicio, id')

                        t=0
                    end
                end
                session[:professor]= @atividades[0].professor_id
                session[:classe=]= @atividades[0].classe_id
                session[:disciplina]= @atividades[0].disciplina_id

                render :update do |page|
                    page.replace_html 'atividades_periodo', :partial => "atividades_consultas_periodo"
                end
            else if params[:type_of].to_i == 3  #NÃO PROGRAMADO
                    if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? ',Time.now.year,  params[:professor][:id]],:order => 'inicio DESC')
                    else if     current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                            @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? and unidade_id =?',Time.now.year,  params[:professor][:id], current_user.unidade_id],:order => 'inicio DESC')

                        else
                            @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? ',Time.now.year,  params[:professor][:id]],:order => 'inicio DESC')
                        end
                    end
                    session[:professor]= @atividades[0].professor_id
                    session[:classe=]= @atividades[0].classe_id
                    session[:disciplina]= @atividades[0].disciplina_id

                    render :update do |page|
                        page.replace_html 'atividades', :partial => "atividades_consultas"
                    end
                else if params[:type_of].to_i == 4

                        @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and unidade_id=? ',Time.now.year,  params[:unidade][:id]],:order => 'inicio DESC')

                        w=session[:professor]= @atividades[0].professor_id
                        w1=session[:classe=]= @atividades[0].classe_id
                        w2=session[:disciplina]= @atividades[0].disciplina_id
                        t=0
                        render :update do |page|
                            page.replace_html 'atividades', :partial => "atividades_consultas"
                        end
                    else if params[:type_of].to_i == 5
                            if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                                @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? ',Time.now.year,  params[:disciplina][:id]],:order => 'inicio DESC')
                            else if  current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? and unidade_id =? ',Time.now.year,  params[:disciplina][:id], current_user.unidade_id],:order => 'inicio DESC')
                                else
                                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? and professor_id =? ',Time.now.year,  params[:disciplina][:id], current_user.professor_id],:order => 'inicio DESC')
                                end
                            end
                            session[:professor]= @atividades[0].professor_id
                            session[:classe=]= @atividades[0].classe_id
                            session[:disciplina]= @atividades[0].disciplina_id

                            render :update do |page|
                                page.replace_html 'atividades', :partial => "atividades_consultas"
                            end
                        else if params[:type_of].to_i == 6

                                session[:dia_final]=params[:diaF]
                                session[:mesF]=params[:mesF]
                                session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
                                session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                                session[:mes]=params[:conteudo][:fim][3,2]
                                session[:anoI]=params[:conteudo][:inicio][6,4]
                                session[:anoF]=params[:conteudo][:fim][6,4]

                                if  current_user.has_role?('admin')  or   current_user.has_role?('SEDUC')
                                    @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year],  :order => 'professors.nome ASC' )
                                else if  current_user.has_role?('pedagogo') or   current_user.has_role?('direcao_fundamental')  or   current_user.has_role?('supervisao')
                                        @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ?  and atividades.unidade_id =? ", session[:dataI], session[:dataF], Time.now.year, current_user.unidade_id ],  :order => 'professors.nome ASC' )

                                    else
                                        @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ?  and atividades.professor_id =? ", session[:dataI], session[:dataF], Time.now.year, current_user.professor_id ],  :order => 'professors.nome ASC' )
                                    end
                                end
                                session[:professor]= @atividades[0].professor_id
                                session[:classe=]= @atividades[0].classe_id
                                session[:disciplina]= @atividades[0].disciplina_id
                                #                                   @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado = 0", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
                                render :update do |page|
                                    page.replace_html 'atividades', :partial => "atividades_consultas"
                                end
                            end
                        end
                    end
                end
            end
        end

    end

    def editar_avaliacao

    end

    def editar_avaliacoes
        session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
        session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividade][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
        session[:professor]=params[:professor][:id]
        session[:classe]=params[:classe][:id]
        session[:disciplina]=params[:disciplina]
        @atividade_avaliacao_alunos= AtividadeAvaliacao.find(:all, :conditions =>  ['atividade_id =? ',  session[:atividade_show]])
        @atividades= Atividade.find(:all, :conditions=>[ 'professor_id=? and	classe_id =?  and	disciplina_id=? and inicio>=?  and fim<=?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
        render :update do |page|
            page.replace_html 'atividades', :partial => "atividades_editar_avaliacoes"
        end
    end

    def editar_avaliacoes2
        @atividade = Atividade.find(params[:id])
        w= session[:atividade_show]=params[:id]
        #@atividades= Atividade.find(:all, :conditions=>[ 'professor_id=? and	classe_id =?  and	disciplina_id=? and inicio>=?  and fim<=?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF]])
        @atividade_avaliacao= AtividadeAvaliacao.find(:all, :joins => 'inner join atividades on atividades.id = atividade_avaliacaos.atividade_id', :conditions =>  ['atividade_avaliacaos.professor_id=? and atividade_avaliacaos.classe_id =?  and	atividade_avaliacaos.disciplina_id=?and atividades.inicio>=?  and atividades.fim<=? and atividades.id =?',  session[:professor], session[:classe] , session[:disciplina],session[:dataI], session[:dataF],session[:atividade_show]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
    end
end
