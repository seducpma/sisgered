class ConteudosController < ApplicationController
  # GET /conteudos
  # GET /conteudos.xml
     before_filter :load_dados_iniciais


   def load_dados_iniciais
 session[:usuario_id]=current_user.unidade_id
 session[:usuario_id]=current_user.professor_id
       if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('Supervisão')
          @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
          @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
              else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil') or    current_user.has_role?('pedagogo')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                   else if current_user.has_role?('professor_fundamental')
                         @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
                         @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ?' , Time.now.year,current_user.professor_id ], :order => 'classes.classe_classe ASC')
                          else if  current_user.has_role?('direcao_fundamental')   or    current_user.has_role?('secretaria_fundamental') or    current_user.has_role?('pedagogo')
                               @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                                @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ? AND unidades.id = ?' , Time.now.year,current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                              end

                          end
                    end
              end
       end
  end

def classe
    w=session[:professor_id]=params[:conteudo_professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
    if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
       if @atribuicao.count > 1
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
 @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and disciplina_id =?", session[:professor_id], Time.now.year, params[:disciplina_id] ])
 session[:cont_classe_id]= @atribuicao[0].classe_id
 session[:cont_atribuicao_id]=@atribuicao[0].id

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

  # GET /conteudos/new
  # GET /conteudos/new.xml
  def new
    @conteudo = Conteudo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end

  # GET /conteudos/1/edit
  def edit
    @conteudo = Conteudo.find(params[:id])
  end

  # POST /conteudos
  # POST /conteudos.xml
  def create
    @conteudo = Conteudo.new(params[:conteudo])
    @conteudo.disciplina_id= session[:cont_disciplina_id]
    @conteudo.classe_id= session[:cont_classe_id]
    @conteudo.atribuicao_id= session[:cont_atribuicao_id]
    @conteudo.atribuicao_id.ano_letivo =  Time.now.year
    respond_to do |format|
      if @conteudo.save
        flash[:notice] = 'Conteudo was successfully created.'
        format.html { redirect_to(@conteudo) }
        format.xml  { render :xml => @conteudo, :status => :created, :location => @conteudo }
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

    respond_to do |format|
      if @conteudo.update_attributes(params[:conteudo])
        flash[:notice] = 'Conteudo was successfully updated.'
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
      format.html { redirect_to(conteudos_url) }
      format.xml  { head :ok }
    end
  end

  def consulta_conteudo
t=0
    if params[:type_of].to_i == 3
        t=0
            session[:aluno_imp]= params[:aluno_fapea]
            session[:ano_imp]=params[:ano_letivo]
            session[:impressao]= 1
            session[:tipo]=0
            @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?  and ano_letivo=?", params[:aluno_fapea], Time.now.year])
            #@matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno], Time.now.year], :order => ["id DESC"])
            @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea], Time.now.year], :order => ["id DESC"])
            ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? ', @relatorios[0].atribuicao_id] )
            @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id] )
            ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
            @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
            #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN relatorios ON professors.id = relatorios.professor_id", :conditions => ['relatorios.id=?', params[:id]])

            session[:poraluno] = 1
            render :update do |page|
               page.replace_html 'relatorio', :partial => "fapea"
           end


    else if params[:type_of].to_i == 1
        w=session[:tiporelatorio]=1
        #w1=session[:professor_id]=params[:conteudo][:professor_id]
        w2=session[:dia_final]=params[:diaF]
        w3=session[:mesF]=params[:mesF]
        w4=session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
        w5=session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
        w6=session[:mes]=params[:conteudo][:fim][3,2]
        w7=session[:anoI]=params[:conteudo][:inicio][6,4]
        w8=session[:anoF]=params[:conteudo][:fim][6,4]
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
            @conteudos = Conteudo.find(:all, :conditions =>  ["inicio >=? AND fim <=?   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :order => 'classe_id ASC')
            @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
            @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=?   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
               w1=current_user.unidade_id
                w2=current_user.professor_id
                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year] , :order => 'classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             else
                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND fim <=? AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND unidade_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             end
        end
        render :update do |page|
            page.replace_html 'relatorio', :partial => 'conteudo'
        end
        else  if params[:type_of].to_i == 2

                 if ( params[:aluno].present?)
                 w= session[:aluno_imp]= params[:aluno]
                  session[:aluno_imp]
                  session[:ano_imp]=params[:ano_letivo]
                  session[:tipo]=0
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno], Time.now.year])

                  @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =? AND (status != 'REMANEJADO')", params[:aluno], Time.now.year], :order => ["id DESC"])
                  ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, Time.now.year] )
                  @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id])

                  ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapea"
                   end
                end
              else if params[:type_of].to_i == 4
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
                            @conteudos = Conteudo.find(:all, :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :order => 'classe_id ASC')
                            @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                            t=0
                        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                               w1=current_user.unidade_id
                                w2=current_user.professor_id
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             else
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
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
