class RelatoriosController < ApplicationController
  # GET /relatorios
  # GET /relatorios.xml
   before_filter :load_dados_iniciais
   before_filter :load_consulta_ano

  


def consulta_registros   # naõ concluida programação
  t=0
    if params[:type_of].to_i == 3  #não existe


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
            #@conteudos = Conteudoprogramaticos.find(:all, :conditions =>  ["inicio >=? AND (fim <=?)   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :order => 'inicio DESC, classe_id ASC')
            @conteudos = Conteudoprogramatico.find(:all,:joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND (fim <=?) ", session[:dataI], session[:dataF]],  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
            @conteudos_professor = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.professor_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN professors ON conteudoprogramaticos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
            @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=?   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
               w=current_user.unidade_id
               w1= current_user.professor_id
                @conteudos = Conteudoprogramatico.find(:all, :joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND  fim <=? AND professor_id = ? AND disciplina_id IS NOT NULL ", session[:dataI], session[:dataF],current_user.professor_id] ,  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
                @conteudos_professor = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.professor_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN professors ON conteudoprogramaticos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             else
                  @dataF = Conteudoprogramatico.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND (fim >=?  or fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
                  session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                @conteudos_professor = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.professor_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN professors ON conteudoprogramaticos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND conteudoprogramaticos.unidade_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND conteudoprogramaticos.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             end
        end
        render :update do |page|
            page.replace_html 'relatorio', :partial => 'conteudo'
        end
        else  if params[:type_of].to_i == 2   #aluno

                   session[:aluno_id]=params[:aluno_id]
                   t=0



              else if params[:type_of].to_i == 4    #classe

                       if current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental')
                        @disciplinas1 = Disciplina.find(:all, :select => "disciplinas.id as disc_id, atribuicaos.id as atri_id, CONCAT(disciplinas.disciplina, ' - ',classes.classe_classe,' - ',unidades.nome) AS disciplina_classe", :joins => "INNER JOIN atribuicaos on disciplinas.id = atribuicaos.disciplina_id INNER JOIN classes on classes.id = atribuicaos.classe_id INNER JOIN unidades ON unidades.id = classes.unidade_id" ,:conditions => ['disciplinas.nao_disciplina = 0 AND atribuicaos.professor_id = ? AND atribuicaos.ano_letivo =?', current_user.professor_id, Time.now.year ],:order => 'disciplina ASC' )
                       end

                       w=session[:disciplina_id]=params[:disciplina_id]
                       w2= session[:cons_data]=0

                        w1=session[:cont_classe_id]=params[:classe_id]
                        t=session[:disciplina_id]
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                          w=session[:disciplina_id]
                              @conteudos = Conteudoprogramatico.find(:all, :conditions =>  ["classe_id = ?", session[:classe_id]], :order => 'inicio DESC, classe_id ASC')
#                              @conteudos_professor = Conteudoprogramatico.find(:all, :select => " count( conteudoprogramaticos.id ) as conta, disciplina_id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ? ", session[:cont_classe_id], session[:disciplina_id]], :order => 'classe_id ASC' )
#                              @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :order => 'classes.classe_classe ASC' )
t=0
                        else if (current_user.has_role?('professor_infantil')  or current_user.has_role?('direcao_infantil'))
                                w1=current_user.unidade_id
                                w2=current_user.professor_id
                                w3=session[:cont_classe_id]
                                w4= session[:disciplina_id]
                                t=0
                                 if current_user.has_role?('professor_infantil')
                                        @conteudos = Conteudoprogramatico.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id],  current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_professor = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.professor_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN professors ON conteudoprogramaticos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                                   else
                                        @conteudos = Conteudoprogramatico.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_professor = Conteudoprogramatico.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_classe = Conteudoprogramatico.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                   end

                           else if ( current_user.has_role?('professor_fundamental') or current_user.has_role?('direcao_fundamental')  )
                                w1=current_user.unidade_id
                                w2=current_user.professor_id
                                    if current_user.has_role?('professor_fundamental')
                                        if current_user.unidade_id == 1   # professor da tempo de viver
                                           w1= session[:cont_classe_id]
                                           w3= current_user.professor_id
                                          @conteudos = Conteudoprogramatico.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?  AND professor_id=?", session[:cont_classe_id],  current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                          @conteudos_professor = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.professor_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN professors ON conteudoprogramaticos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                          @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                                        else
                                           w1= session[:cont_classe_id]
                                           w2=session[:disciplina_id]
                                           w3= current_user.professor_id
                                          @conteudos = Conteudoprogramatico.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=? AND professor_id=?", session[:cont_classe_id],session[:disciplina_id],  current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                          @conteudos_professor = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.professor_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN professors ON conteudoprogramaticos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                          @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                                          t=0
                                      end
                                    else
                                        @conteudos = Conteudoprogramatico.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=?", session[:cont_classe_id],session[:disciplina_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_professor = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.professor_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN professors ON conteudoprogramaticos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        @conteudos_classe = Conteudoprogramatico.find(:all, :select => "conteudoprogramaticos.classe_id, count( conteudoprogramaticos.id ) as conta",:joins => "INNER JOIN classes ON conteudoprogramaticos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

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

  def index
    @relatorios = Relatorio.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @relatorios }
    end
  end

  # GET /relatorios/1
  # GET /relatorios/1.xml
  def show
    @relatorio = Relatorio.find(params[:id])
    @classe = Atribuicao.find(:all, :joins => :disciplina, :select=> 'classe_id, disciplinas.disciplina AS disc', :conditions => ['atribuicaos.id=? ', @relatorio.atribuicao_id])
    @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
    #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN relatorios ON professors.id = relatorios.professor_id", :conditions => ['relatorios.id=?', params[:id]])
    #@professors = Professor.find(:all, :select => 'nome', :joins  => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.id=? ano_letivo =?' , @classe[0].classe_id, Time.now.year])
    session[:imprimir_todos]=0
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/new
  # GET /relatorios/new.xml
  def new
    @relatorio = Relatorio.new
    @maximum_length = Relatorio.validates_length_of :observacao, :in => 0..12000
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/1/edit
  def edit
    @relatorio = Relatorio.find(params[:id])

###Alex 28/06/19 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? ', @relatorio.atribuicao_id] )
    @classe = Atribuicao.find(:all, :joins => :disciplina, :select=> 'classe_id, disciplinas.disciplina AS disc', :conditions => ['atribuicaos.id=? ', @relatorio.atribuicao_id])
    #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
    @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN relatorios ON professors.id = relatorios.professor_id", :conditions => ['relatorios.id=?', params[:id]])
  end

  # POST /relatorios
  # POST /relatorios.xml
  def create
    @relatorio = Relatorio.new(params[:relatorio])
    @relatorio.ano_letivo =  Time.now.year
    w=@relatorio.faltas=params[:faltas]
    w1=@relatorio.dias_letivos = params[:dias_letivos]

    t=0


    @relatorio.professor_id = session[:professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
    @relatorio.atribuicao_id= @atribuicao[0].id
    session[:poraluno] = 1
    session[:aluno_imp]= @relatorio.aluno_id

    respond_to do |format|
      if @relatorio.save

#        if @relatorio.dias_letivos == 0
#          w3=session[:aulas]=1
#        else
#          w4=session[:aulas]=@relatorio.dias_letivos
#        end
#        if @relatorio.faltas == 0
#          w2=session[:faltas]=1
#        else
#          w1=session[:faltas]=@relatorio.faltas
#        end
        session[:faltas]=@relatorio.faltas
        if @relatorio.dias_letivos == 0
          session[:faltas]=0
          @relatorio.faltas=0
          @relatorio.frequencia=0
        else
          session[:aulas]=@relatorio.dias_letivos
          if @relatorio.faltas == 0
            @relatorio.frequencia=100
          else
            @relatorio.frequencia=100-((session[:faltas].to_f/session[:aulas].to_f)*100)
          end
        end
        @relatorio.save

        flash[:notice] = 'RELATORIO SALVO COM SUCESSO'
        format.html { redirect_to(@relatorio) }
        format.xml  { render :xml => @relatorio, :status => :created, :location => @relatorio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /relatorios/1
  # PUT /relatorios/1.xml
  def update
      @relatorio = Relatorio.find(params[:id])
      session[:faltas]=@relatorio.faltas
      session[:aulas]=@relatorio.dias_letivos
      if @relatorio.dias_letivos == 0
          session[:faltas]=0
          @relatorio.faltas=0
          @relatorio.frequencia=0
      else
          session[:aulas]=@relatorio.dias_letivos
          if @relatorio.faltas == 0
              @relatorio.frequencia=100
          else
              @relatorio.frequencia = 100-((session[:faltas].to_f / session[:aulas].to_f)*100)
          end
      end

      respond_to do |format|
          if @relatorio.update_attributes(params[:relatorio])
              flash[:notice] = 'RELATORIO SALVO COM SUCESSO'
              format.html { redirect_to(@relatorio) }
              format.xml  { head :ok }
          else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
          end
      end
  end

  # DELETE /relatorios/1
  # DELETE /relatorios/1.xml
  def destroy
    @relatorio = Relatorio.find(params[:id])
    @relatorio.destroy

    respond_to do |format|
      format.html { redirect_to(home_path) }
      format.xml  { head :ok }
    end
  end


  def professor
    session[:professor_id]=params[:relatorio_professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
    cont_cl=0
    for atribuicao in @atribuicao
        @aluno= Matricula.find(:all, :select => 'alunos.id, alunos.aluno_nome',:joins =>:aluno  ,:conditions=>['matriculas.classe_id=? AND (matriculas.status ="MATRICULADO" OR matriculas.status ="TRANSFERENCIA" OR matriculas.status ="*REMANEJADO")AND ano_letivo =? ', atribuicao.classe_id, Time.now.year], :order => 'alunos.aluno_nome ASC')
        if cont_cl==0
          @alunos2=@aluno
          cont_cl=cont_cl+1
        else
          @alunos2=@alunos2 + @aluno
          cont_cl=cont_cl+1
        end
    end

       render :partial => 'aluno_classe'
  end


  def consulta_relatorio
      @relatorio = Relatorio.find(:all, :conditions => ['aluno_id =?', params[:aluno_id]])
  end

  def fapea_ano

      if current_user.has_role?('admin')or current_user.has_role?('SEDUC')  or current_user.has_role?('supervisao')or current_user.has_role?('direcao_fundamental') or current_user.has_role?('direcao_infantil')or   current_user.has_role?('pedagogo')
        @fapea_ano = Relatorio.find(:all, :joins => :aluno, :conditions=> ['ano_letivo =? and alunos.unidade_id=?' , params[:ano_letivo], current_user.unidade_id])
        ###Alex - mudei no SQL de cima para puxar só da unidade, para diminuir a lista neste momento - AlexML - 25/06/19 12:11 - @fapea_ano = Relatorio.find(:all, :conditions=> ['ano_letivo =?' , params[:ano_letivo]])
        @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.aluno_status is null AND ano_letivo=?', params[:ano_letivo] ],:order => 'alunos.aluno_nome ASC')

      else
        @fapea_ano = Relatorio.find(:all, :joins=> :aluno, :conditions=> ['ano_letivo =? and alunos.unidade_id=?' , params[:ano_letivo], current_user.unidade_id])
        if  current_user.has_role?('professor_infantil')
         #  @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND relatorios.ano_letivo=?', current_user.unidade_id, params[:ano_letivo] ],:order => 'alunos.aluno_nome')
        #session[:professor_id]=params[:relatorio_professor_id]
            @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", current_user.professor_id, Time.now.year ])
            cont_cl=0
            for atribuicao in @atribuicao
                @aluno= Matricula.find(:all, :select => 'alunos.id, alunos.aluno_nome',:joins =>:aluno  ,:conditions=>['matriculas.classe_id=? AND (matriculas.status ="MATRICULADO" OR matriculas.status ="TRANSFERENCIA" OR matriculas.status ="*REMANEJADO")AND ano_letivo =? ', atribuicao.classe_id, Time.now.year], :order => 'alunos.aluno_nome ASC')
                t=0
                if cont_cl==0
                  @alunosRel=@aluno
                  cont_cl=cont_cl+1
                else
                  @alunosRel=@alunosRel + @aluno
                  cont_cl=cont_cl+1
                end
            end




        else
          # @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nomes), alunos.id', :joins => :aluno,  :conditions =>['alunos.aluno_status is null AND relatorios.ano_letivo=? and alunos.unidade_id=?',  params[:ano_letivo],  current_user.unidade_id ],:order => 'alunos.aluno_nome')
            @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id,  alunos.unidade_id, matriculas.unidade_id, matriculas.ano_letivo, matriculas.id as matriculas_id', :joins => "JOIN `alunos` ON `alunos`.id = `relatorios`.aluno_id JOIN matriculas ON alunos.id = matriculas.aluno_id",  :conditions =>['alunos.aluno_status is null AND relatorios.ano_letivo=? and alunos.unidade_id=? AND matriculas.ano_letivo =? AND matriculas.unidade_id = alunos.unidade_id AND matriculas.unidade_id =?',  params[:ano_letivo],  current_user.unidade_id , params[:ano_letivo],current_user.unidade_id],:order => 'alunos.aluno_nome')
        end
    end
   render :partial => 'selecao_nome'
  end



def consulta_fapea

    if params[:type_of].to_i == 3
        
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
                 if ( params[:aluno_fapea1].present?)
                 w4=session[:aluno_imp]= params[:aluno_fapea1]
                 session[:ano_imp]=params[:ano_letivo]
                 session[:tipo]=1
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]])
                  @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =? AND (status != 'REMANEJADO')", params[:aluno_fapea1], params[:ano_letivo]], :order => ["id DESC"])
                  ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=?', @relatorios[0].atribuicao_id] )
                  @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id] )
                  ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  session[:impressao]= 1
                  session[:poraluno] = 0
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapea"
                   end
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
                   for matricula in @matricula
                        mat_classe_id= matricula.classe_id
                        # mat_classe_id= @matricula[0].classe_id
                   end
                  
                  @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', mat_classe_id])

                  ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapea"
                   end
                end
              else if params[:type_of].to_i == 4
                        session[:type_of] = 4
                         w= session[:classe_id]=params[:classe_id]
                         #w1= session[:semestre]= params[:semestre]
                         session[:tipo]=0
                         w=params[:classe_id]
                         t=0
                           @matriculas = Matricula.find(:all,:conditions =>['classe_id = ? ', params[:classe_id]], :order => 'classe_num ASC')

                           #@classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matriculas[0].classe_id])
                           @classe = Atribuicao.find(:all, :joins => "INNER JOIN `classes` ON `classes`.id = `atribuicaos`.classe_id INNER JOIN `disciplinas` ON `disciplinas`.id = `atribuicaos`.disciplina_id INNER JOIN matriculas ON classes.id = matriculas.classe_id", :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['atribuicaos.classe_id=?', session[:classe_id]])
                           @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                           t=0
                            #if session[:semestre].to_i == 1  # desativado semestre
                            #   render :update do |page|
                            #      page.replace_html 'relatorio', :partial => 'fapea_classe1'
                            #   end
                            #else  if session[:semestre].to_i == 2
                            #           render :update do |page|
                            #              page.replace_html 'relatorio', :partial => 'fapea_classe2'
                            #           end
                            #     else
                                       render :update do |page|
                                          page.replace_html 'relatorio', :partial => 'fapea_classe'
                                       end
                             #    end
                            #end
                      end
             end
        end
    end
  
end



 def impressao_fapea

            @relatorio = Relatorio.find(:all, :conditions => ["id =?", params[:id]])
##            @relatorio = Relatorio.find(:last, :conditions => ["aluno_id =?", session[:aluno_imp]])
            if session[:tipo]==1
                 @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", session[:aluno_imp], session[:ano_imp]], :order => ["id DESC"])
                 session[:tipo]=0
            else
                
                @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", session[:aluno_imp], Time.now.year], :order => ["id DESC"])
                session[:tipo]=0
            end
            session[:relatorio_id]=params[:id]
            ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorio.atribuicao_id, Time.now.year] )

            #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN relatorios ON professors.id = relatorios.professor_id", :conditions => ['relatorios.id=?', session[:relatorio_id]])

            if session[:type_of] == 4
                 @matricula = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
                 @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id])
                 @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                 session[:type_of] = 0

            else

                @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id])
                @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])

            end

            #if session[:imprimir_todos] == 0
               # @relatorios = Relatorio.find(:all, :conditions => ["id =?", session[:relatorio_id]])
            #else
                 #@relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? ", session[:aluno_imp]])
            #end
     render :layout => "impressao"
  end


  def impressao_fapea1
      t=0
     @relatorio = Relatorio.find(:all, :conditions => ["id =?", params[:id]])
            if session[:type_of] == 4
                 @matricula = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
                 @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id])
                 @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                 session[:type_of] = 0
            else

                @matricula = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
                @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id])

                @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
            end

     render :layout => "impressao"

  end

   def impressao_fapea2
     @relatorio = Relatorio.find(:all, :conditions => ["id =?", params[:id]])
            if session[:type_of] == 4
                 @matricula = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
                 @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id])
                 @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                 session[:type_of] = 0
            else
                @matricula = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
                @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id])
                @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
            end
     render :layout => "impressao"

   end




  def impressao_fapeaT
      @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
      @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matriculas[0].classe_id])
      @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
     render :layout => "impressao"
  end

  def impressao_fapeaT1

      @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')

      @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matriculas[0].classe_id])
      @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
     render :layout => "impressao"
  end

  def impressao_fapeaT2
      @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
      @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matriculas[0].classe_id])
      @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
     render :layout => "impressao"
  end



   def impressao_fapeaTT1
      @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
      @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matriculas[0].classe_id])
      @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
     render :layout => "impressao"
  end

  def impressao_fapeaTT2
      @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
      @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matriculas[0].classe_id])
      @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
     render :layout => "impressao"
  end

def editar

    if params[:type_of].to_i == 3
        if ( params[:aluno_fapea].present?)
            session[:aluno_imp]= params[:aluno_fapea]
            session[:ano_imp]=params[:ano_letivo]
            session[:impressao]= 1
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?", params[:aluno_fapea]])
                  @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea], Time.now.year], :order => ["id DESC"])
                  ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, Time.now.year] )
                  @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id] )
                  ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'professors.nome, professors.id', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
#                  @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? ', @relatorios[0].atribuicao_id] )
#                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
            session[:poraluno] = 1
                  if (@professors[0].id==current_user.professor_id)
                        session[:prof_autorizado]=true
                  else
                        session[:prof_autorizado]=false
                  end
           render :update do |page|
               page.replace_html 'relatorio', :partial => "fapeaE"
           end
      end
    else if params[:type_of].to_i == 1
                 if ( params[:aluno_fapea1].present?)
                  session[:aluno_imp]= params[:aluno_fapea1]
                  session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]])
                  @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]], :order => ["id DESC"])
#                 @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, params[:ano_letivo]] )
                  @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id] )
                  @professors = Professor.find(:all, :select => 'professors.nome, professors.id', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  session[:impressao]= 1
                  session[:poraluno] = 0

                  if (@professors[0].id==current_user.professor_id)
                        session[:prof_autorizado]=true
                  else
                        session[:prof_autorizado]=false
                  end

                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapeaE"
                   end
                end
        else  if params[:type_of].to_i == 2
                 if ( params[:aluno].present?)
                  session[:aluno_imp]= params[:aluno]
                  session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno], params[:ano_letivo]])
                  @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]], :order => ["id DESC"])
#                 @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, Time.now.year] )
                  @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id] )
                  @professors = Professor.find(:all, :select => 'professors.nome, professors.id', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  if (@professors[0].id==current_user.professor_id)
                        session[:prof_autorizado]=true
                  else
                        session[:prof_autorizado]=false
                  end
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapeaE"
                   end
                end
             end
        end
    end

end


def consulta_observacoes
    if params[:type_of].to_i == 1
       if ( params[:aluno].present?)
            session[:aluno_imp]= params[:aluno2]
            session[:ano_imp]=params[:ano_letivo]
            @notas = Nota.find(:all,  :conditions => ["aluno_id =?   AND ano_letivo =?", session[:aluno_imp], session[:ano_imp]])
            @matriculas = Matricula.find(:all, :conditions => ["aluno_id =?   AND ano_letivo =?",session[:aluno_imp], session[:ano_imp]])
            @aluno = Aluno.find(:all,:conditions =>['id = ? AND aluno_status is null', session[:aluno_imp]])
            @matriculas.each do |matricula|
               session[:classe]=matricula.classe_id
               session[:num]=matricula.classe_num
             end
            @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
            @classe.each do |classe|
               session[:unidade]=classe.unidade_id
             end
            session[:impressao]= 0

            render :update do |page|
               page.replace_html 'relatorio', :partial => "observacoes"
           end
       end
    else if params[:type_of].to_i == 2

                 if ( params[:aluno1].present?)
                    session[:aluno_imp]= params[:aluno1]
                    session[:disciplina]=params[:disciplina2]
                    @notas = Nota.find(:all,  :conditions => ["aluno_id =? and disciplina_id=?", session[:aluno_imp], session[:disciplina]])
                    @matriculas = Matricula.find(:all, :conditions => ["aluno_id =?  ",session[:aluno_imp],])
                    @aluno = Aluno.find(:all,:conditions =>['id = ? AND aluno_status is null', session[:aluno_imp]])
                    @matriculas.each do |matricula|
                        session[:classe]=matricula.classe_id
                     end

                     @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
                     @classe.each do |classe|
                     session[:unidade]=classe.unidade_id
                end
                   session[:impressao]= 0

                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "observacoes3"
                   end
                end
        else  if params[:type_of].to_i == 3
                   if ( params[:aluno].present?)
                        session[:aluno_imp]= params[:aluno]
                        @notas = Nota.find(:all,  :conditions => ["aluno_id =?", session[:aluno_imp]])
                        @matriculas = Matricula.find(:all, :conditions => ["aluno_id =?  ",session[:aluno_imp],])
                        @aluno = Aluno.find(:all,:conditions =>['id = ? AND aluno_status is null', session[:aluno_imp]])

                       @matriculas.each do |matricula|
                           session[:classe]=matricula.classe_id
                         end
                        @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
                        @classe.each do |classe|
                           session[:unidade]=classe.unidade_id
                         end
                        session[:impressao]= 0
                        
                        render :update do |page|
                           page.replace_html 'relatorio', :partial => "observacoes3"
                       end
                   end
             end
        end
    end
end

  def relatorio
     if ( params[:aluno].present?)
       session[:aluno_imp]= params[:aluno]
       session[:ano_imp]=params[:ano_letivo]
      @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno], params[:ano_letivo]])

        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @relatorios }
        end
    end
  end

  def impressao_fapeaxxxxxx
      if session[:poraluno]==1
            @relatorio = Relatorio.find(:last, :conditions => ["aluno_id =?", session[:aluno_imp]])
            @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", session[:aluno_imp], session[:ano_imp]], :order => ["id DESC"])
            session[:relatorio_id]=@relatorio.id
            ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorio.atribuicao_id, Time.now.year] )
            @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id] )
            @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN relatorios ON professors.id = relatorios.professor_id", :conditions => ['relatorios.id=?', session[:relatorio_id]])
            #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
            if session[:imprimir_todos] == 0
                @relatorios = Relatorio.find(:all, :conditions => ["id =?", session[:relatorio_id]])
            else
                 @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? ", session[:aluno_imp]])
            end
            session[:imprimir_todos]=0
             session[:poraluno]=0
      else
         @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?", session[:aluno_imp]])
         @matricula = Matricula.find(:all, :conditions => ["aluno_id =?", session[:aluno_imp]], :order => ["id DESC"])
         ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, session[:ano_imp]] )
         @classe = Atribuicao.find(:all, :joins => [:classe, :disciplina], :select=> 'atribuicaos.classe_id, classes.classe_classe, disciplinas.disciplina AS disc', :conditions => ['classe_id=?', @matricula[0].classe_id] )
         ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
         @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
      end
     render :layout => "impressao"
  end


 


 

  
  def dados
    w=session[:professor_id]
    session[:alun_id]=params[:relatorio_aluno_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? AND ano_letivo=?", session[:professor_id],Time.now.year])
    @aluno = Aluno.find(:all, :conditions => ["id=?", params[:relatorio_aluno_id]])
    render :update do |page|
          page.replace_html 'dados_aluno', :partial => 'dados'
          page.replace_html 'dados_aluno1', :partial => 'dados_pais'
       end
  end

  def load_dados_iniciais
       unidade=  current_user.unidade_id
       if (current_user.unidade_id > 41  and  current_user.unidade_id < 52) or current_user.unidade_id == 62 # unidade de  ensino fundamental
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id > 41 AND id <52'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all,:conditions =>['id = ?', current_user.unidade_id], :order => 'nome ASC')
         @disciplinas= Disciplina.find(:all, :conditions =>['curriculo != "I" and ano_letivo =? ', (Time.now.year)], :order =>'disciplina'  )
       else
         #@alunosRel = Relatorio.find(:all, :select => 'alunos.id, alunos.aluno_nome', :joins => :aluno,  :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null', current_user.unidade_id ],:order => 'alunos.aluno_nome')
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id < 40  OR id >51'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all, :order => 'nome ASC')
         @disciplinas= Disciplina.find(:all, :conditions =>['curriculo =? and ano_letivo =? ', 'I', (Time.now.year)], :order =>'disciplina'  )
       end
       #@alunos2 = Aluno.find(:all, :select => 'alunos.id, alunos.aluno_nome', :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id INNER JOIN classes ON classes.id = matriculas.classe_id INNER JOIN atribuicaos ON classes.id = atribuicaos.classe_id", :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND atribuicaos.professor_id =?', current_user.unidade_id, current_user.professor_id ],:order => 'alunos.aluno_nome')       #@alunos3 = Aluno.find(:all, :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id", :conditions =>['alunos.unidade_id=? AND (matriculas.status = "MATRICULADO" OR matriculas.status = "*REMANEJADO" OR matriculas.status = "TRANSFERENCIA")  ', current_user.unidade_id],:order => 'alunos.aluno_nome')
      
       if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('Supervisão')
          @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
          @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.aluno_status is null'],:order => 'alunos.aluno_nome ASC')
       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
              @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => [:professor, :aluno], :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND relatorios.professor_id =?', current_user.unidade_id, current_user.professor_id ],:order => 'alunos.aluno_nome')
              else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil') or    current_user.has_role?('pedagogo')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                   @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null', current_user.unidade_id ],:order => 'alunos.aluno_nome')
                   t=0
                 end
           end
       end

  end

  def load_consulta_ano
    @ano =   Relatorio.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
    @ano1 =   Nota.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
    @disciplina=  Disciplina.find(:all,:select => 'distinct(disciplina) as disciplina', :conditions => ['ano_letivo =? and tipo_un =?', Time.now.year, 3] ,:order => 'ano_letivo DESC')
  end
end

def consulta
end




