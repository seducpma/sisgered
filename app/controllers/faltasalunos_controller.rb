class FaltasalunosController < ApplicationController
  # GET /faltasalunos
  # GET /faltasalunos.xml
 before_filter :load_dados_iniciais

    def load_dados_iniciais
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


 def alunos
    a=session[:classe_id]= params[:classe_id]
  #  a1=   session[:professor_id]=params[:professor_id]

  # a2=session[:data]= params[:data]
    t=0
     @alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
        render :partial => 'alunos'
end

 def data
   session[:dia]= params[:faltasalunos_data]

 end
  def disciplina
   session[:disciplina_id]= params[:disciplina_id]
   
 end

 def faltas
   session[:falta]= params[:falta]
   
 end

 def obser
   session[:obser]=params[:aluno_nome]
 end


 def alunos_faltas_falta
 
     @alunos_faltaram=  Aluno.find(params[:aluno_ids], :order => 'aluno_nome ASC')
      w1=session[:professor_id]
      w2=session[:classe_id]
      w3=session[:disciplina_id]
     @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and classe_id=? and disciplina_id =?", session[:professor_id], Time.now.year , session[:classe_id], session[:disciplina_id]])
     t=0
     if @atribuicao.empty?
        respond_to do |format|
                    #flash[:notice] = 'CADASTRADO COM SUCESSO.'
                    format.html { redirect_to(aviso_faltasalunos_path) }
                    format.xml  { head :ok }
                end
     else
     
     for aluno in @alunos_faltaram
          @faltasaluno = Faltasaluno.new
           @matricula= Matricula.find(:all, :conditions=> ['aluno_id=? and classe_id=?', aluno.id, session[:classe_id]])   # precisa também verificar o estado da matricula
           @faltasaluno.aluno_id = aluno.id
           @faltasaluno.matricula_id=@matricula[0].id
           @faltasaluno.atribuicao_id=@atribuicao[0].id
           @faltasaluno.professor_id=session[:professor_id]
           @faltasaluno.unidade_id=@matricula[0].unidade_id
           @faltasaluno.disciplina_id=session[:disciplina_id]
           @faltasaluno.user_id=current_user.id
           @faltasaluno.classe_id=session[:classe_id]
           @faltasaluno.ano_letivo = Time.now.year
           @faltasaluno.data=session[:dia]
           @faltasaluno.faltas=session[:falta]
           @faltasaluno.obs=session[:obser]
           @faltasaluno.save
           @faltasaluno = Faltasaluno.find(:last)
    end
  end
end

def classe
   session[:professor_id]=params[:professor_id]

   session[:data]= params[:data]
   
  
#   @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
 
#    if @atribuicao.empty? or @atribuicao.nil?
#      render :partial => 'aviso'
#    else
#        @classes = Classe.find(:all, :select => "disciplinas.id as disc_id, classes.unidade_id,  atribuicaos.disciplina_id as disciplina,  classes.id as classe_id, CONCAT(classes.classe_classe, ' - ',disciplinas.disciplina,' - ',unidades.nome) AS classe", :joins => "INNER JOIN atribuicaos on classes.id = atribuicaos.classe_id INNER JOIN disciplinas on disciplinas.id = atribuicaos.disciplina_id INNER JOIN unidades ON unidades.id = classes.unidade_id" ,:conditions => ['disciplinas.nao_disciplina = 0 AND atribuicaos.professor_id = ? AND atribuicaos.ano_letivo =?', session[:professor_id], Time.now.year ],:order => 'disciplina ASC' )
#        render :partial => 'classe'
#    end
  end

    def lancar_faltas_diario

    end

  def index
    @faltasalunos = Faltasaluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @faltasalunos }
    end
  end

  # GET /faltasalunos/1
  # GET /faltasalunos/1.xml
  def show
    @faltasaluno = Faltasaluno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @faltasaluno }
    end
  end

  # GET /faltasalunos/new
  # GET /faltasalunos/new.xml
  def new
    @faltasaluno = Faltasaluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @faltasaluno }
    end
  end

  # GET /faltasalunos/1/edit
  def edit
    @faltasaluno = Faltasaluno.find(params[:id])
  end

  # POST /faltasalunos
  # POST /faltasalunos.xml
  def create
    @faltasaluno = Faltasaluno.new(params[:faltasaluno])
    respond_to do |format|
      if @faltasaluno.save
        flash[:notice] = 'Faltasaluno was successfully created.'
        format.html { redirect_to(@faltasaluno) }
        format.xml  { render :xml => @faltasaluno, :status => :created, :location => @faltasaluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @faltasaluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /faltasalunos/1
  # PUT /faltasalunos/1.xml
  def update
    @faltasaluno = Faltasaluno.find(params[:id])

    respond_to do |format|
      if @faltasaluno.update_attributes(params[:faltasaluno])
        flash[:notice] = 'Faltasaluno was successfully updated.'
        format.html { redirect_to(@faltasaluno) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @faltasaluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /faltasalunos/1
  # DELETE /faltasalunos/1.xml
  def destroy
    @faltasaluno = Faltasaluno.find(params[:id])
    @faltasaluno.destroy

    respond_to do |format|
      format.html { redirect_to(faltasalunos_url) }
      format.xml  { head :ok }
    end
  end

    def classe_disciplina
       params[:classe_id]
       @disciplina_classe = Disciplina.find(:all,:joins=> "INNER JOIN atribuicaos ON disciplinas.id = atribuicaos.disciplina_id", :conditions=> ['atribuicaos.classe_id =?', params[:classe_id]])
   render :partial => 'disciplina_classe'
  end

def consulta_faltas
    if params[:type_of].to_i == 3    #NADA
            
    else if params[:type_of].to_i == 1   #data
        session[:cons_data]=1
        
        
        session[:dia_final]=params[:diaF]
        session[:mesF]=params[:mesF]
        w=session[:Ix]=params[:faltasaluno][:inicio]
        session[:dataI]=params[:faltasaluno][:inicio][6,4]+'-'+params[:faltasaluno][:inicio][3,2]+'-'+params[:faltasaluno][:inicio][0,2]
        session[:dataF]=params[:faltasaluno][:fim][6,4]+'-'+params[:faltasaluno][:fim][3,2]+'-'+params[:faltasaluno][:fim][0,2]
        session[:mes]=params[:faltasaluno][:fim][3,2]
        session[:anoI]=params[:faltasaluno][:inicio][6,4]
        session[:anoF]=params[:faltasaluno][:fim][6,4]

        #ATENÇÂO COM A DATA FINAL   VVVVVVVVVVVVV

        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
            #@conteudos = Conteudo.find(:all, :conditions =>  ["inicio >=? AND (fim <=?)   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :order => 'inicio DESC, classe_id ASC')
            @faltasalunos = Faltasaluno.find(:all,:joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND (fim <=?) ", session[:dataI], session[:dataF]],  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
             @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)'    ,:joins =>[:professor, :classe], :conditions =>  ["inicio >=? AND (fim <=?) ", session[:dataI], session[:dataF]],  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
            #?   @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
            #?   @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=?   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                current_user.unidade_id
                current_user.professor_id
                @faltasalunos = Faltasaluno.find(:all, :joins =>[:professor, :classe], :conditions =>  ["data >=? AND  data <=? AND professor_id = ? AND disciplina_id IS NOT NULL ", session[:dataI], session[:dataF],current_user.professor_id] ,  :order => 'professors.nome ASC, data DESC, classe_id ASC' )
                @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)' ,:joins =>[:professor, :classe], :conditions =>  ["data >=? AND  data <=? AND professor_id = ? AND disciplina_id IS NOT NULL ", session[:dataI], session[:dataF],current_user.professor_id] ,  :order => 'professors.nome ASC, data DESC, classe_id ASC' )
                #?   @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                #?  @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

             else
                  @dataF = Conteudo.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND (fim >=?  or fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
                  session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                    @faltasaluno = Faltasaluno.find(:all, :joins =>[:professor, :classe], :conditions =>  ["data >=? AND data <? AND classes.unidade_id = ?   ", session[:dataI], session[:dataF], current_user.unidade_id] ,  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
                    @faltasalunodias = Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>[:professor, :classe], :conditions =>  ["data >=? AND data <? AND classes.unidade_id = ?   ", session[:dataI], session[:dataF], current_user.unidade_id] ,  :order => 'professors.nome ASC, inicio DESC, classe_id ASC' )
                    #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND conteudos.unidade_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    #? @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND conteudos.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             end
        end
        render :update do |page|
            page.replace_html 'relatorio', :partial => 'faltas'
        end
        else  if params[:type_of].to_i == 2     #aluno
                        session[:tela_faltas_aluno]=1
                        session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]
                        session[:dataI]=params[:faltasaluno][:inicioA][6,4]+'-'+params[:faltasaluno][:inicioA][3,2]+'-'+params[:faltasaluno][:inicioA][0,2]
                        session[:dataF]=params[:faltasaluno][:fimA][6,4]+'-'+params[:faltasaluno][:fimA][3,2]+'-'+params[:faltasaluno][:fimA][0,2]
                        session[:mes]=params[:faltasaluno][:fimA][3,2]
                        session[:anoI]=params[:faltasaluno][:inicioA][6,4]
                        session[:anoF]=params[:faltasaluno][:fimA][6,4]
                        session[:dataINI]=session[:dataI][8,2]+'-'+session[:dataI][5,2]+'-'+session[:dataI][0,4]
                        session[:dataFIM]=session[:dataF][8,2]+'-'+session[:dataF][5,2]+'-'+session[:dataF][0,4]
 

                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos = Conteudo.find(:all, :joins =>:classe,  :conditions =>  ["classes.unidade_id = ? and classes.classe_ano_letivo =?", session[:cont_unidade_id], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ? and  classes.classe_ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ?", session[:cont_unidade_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))


                                           w1= session[:aluno]= params[:aluno]
                                           w3= current_user.professor_id
                                           w4=session[:cont_classe_id]
                                          @faltasalunos = Faltasaluno.find(:all, :joins =>:aluno, :conditions =>  ["data >=? AND  data <=? AND aluno_id = ? AND professor_id=?", session[:dataI], session[:dataF],session[:aluno],  current_user.professor_id] , :order => 'data ASC')
                                          #@conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                          @faltasalunosdiasT = Faltasaluno.find(:all, :select=>  'data ,aluno_id, 	matricula_id, 	atribuicao_id, 	aluno_id, 	professor_id,  	disciplina_id , 	ano_letivo  ', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND aluno_id = ? AND disciplina_id=? AND professor_id=?", session[:dataI], session[:dataF],session[:aluno], session[:disciplina_id],  current_user.professor_id] , :order => 'data ASC')
                                          @faltasalunosdias = Faltasaluno.find(:all, :select=>  'data, disciplina_id', :joins =>:aluno, :conditions =>  ["data >=? AND  data <=? AND aluno_id = ? AND professor_id=?", session[:dataI], session[:dataF],session[:aluno],  current_user.professor_id] , :order => 'data ASC')
                                          @faltasalunosdiasAluno = Faltasaluno.find(:all, :select=>  ' disciplina_id, data', :joins =>:aluno, :conditions =>  ["data >=? AND  data <=? AND aluno_id = ? AND professor_id=?", session[:dataI], session[:dataF],session[:aluno],  current_user.professor_id] , :order => 'data ASC')
w=@faltasalunos[0].classe_id=session[:cont_classe_id]
t=0

                                          @alunos_matriculados = Aluno.find(:all, :select => "alunos.id , matriculas.classe_num , alunos.aluno_nome	 ,CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                                          #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                          #? @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
   








                                 #w1=current_user.unidade_id
                                #w2=current_user.professor_id
                                #@conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                #@conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                #@conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             else
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             end
                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'faltas'
                        end
              else if params[:type_of].to_i == 4    #classe
                       session[:disciplina_id]=params[:disciplina_id]
                        session[:cons_data]=0
                        session[:cont_classe_id]=params[:classe_id]

        
                        session[:dataI]=params[:faltasaluno][:inicioC][6,4]+'-'+params[:faltasaluno][:inicioC][3,2]+'-'+params[:faltasaluno][:inicioC][0,2]
                        session[:dataF]=params[:faltasaluno][:fimC][6,4]+'-'+params[:faltasaluno][:fimC][3,2]+'-'+params[:faltasaluno][:fimC][0,2]
                        session[:mes]=params[:faltasaluno][:fimC][3,2]
                        session[:anoI]=params[:faltasaluno][:inicioC][6,4]
                        session[:anoF]=params[:faltasaluno][:fimC][6,4]
                        session[:dataINI]=session[:dataI][8,2]+'-'+session[:dataI][5,2]+'-'+session[:dataI][0,4]
                        session[:dataFIM]=session[:dataF][8,2]+'-'+session[:dataF][5,2]+'-'+session[:dataF][0,4]
 

                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            if session[:disciplina_id]=='--Todas--'
                              @faltasalunos = Faltasaluno.find(:all, :conditions =>  ["data >=? AND  data <=? AND classe_id = ?", session[:dataI], session[:dataF],session[:cont_classe_id]], :order => 'inicio DESC, classe_id ASC')
                              @faltasalunodias = Faltasaluno.find(:all, :select=> 'distinct(data)'  , :conditions =>  ["data >=? AND  data <=? AND classe_id = ?", session[:dataI], session[:dataF],session[:cont_classe_id]], :order => 'inicio DESC, classe_id ASC')
@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                              #?  @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                              #? @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                            else
                              @faltasalunos = Faltasaluno.find(:all, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:dataI], session[:dataF], session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :order => 'inicio DESC, classe_id ASC')
                              @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)', :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:dataI], session[:dataF], session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :order => 'inicio DESC, classe_id ASC')
@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                              #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta, disciplina_id ",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                              #? @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id],  current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                            end
                        else if (current_user.has_role?('professor_infantil')  or current_user.has_role?('direcao_infantil'))
                                w1=current_user.unidade_id
                                w2=current_user.professor_id

                                if session[:disciplina_id]=='--Todas--'
                                  @faltasalunos = Faltasaluno.find(:all, :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND professor_id=?",  session[:dataI], session[:dataF],session[:cont_classe_id], current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                  @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND professor_id=?",  session[:dataI], session[:dataF],session[:cont_classe_id], current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                                  #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                else
                                       w1=session[:cont_classe_id]
                                       w2= session[:disciplina_id]
                                       w3= current_user.professor_id
                                   if current_user.has_role?('professor_infantil')
                                        @faltasalunos = Faltasaluno.find(:all, :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND professor_id=?",   session[:dataI], session[:dataF], session[:cont_classe_id], current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                        @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND professor_id=?",   session[:dataI], session[:dataF], session[:cont_classe_id], current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                                        #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        #?@conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                                   else
                                        @faltasalunos = Faltasaluno.find(:all, :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? ", session[:dataI], session[:dataF], session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? ", session[:dataI], session[:dataF], session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                                       #?@conteudos_professor = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                        #?@conteudos_classe = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? ", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                   end
                                end
                            else if ( current_user.has_role?('professor_fundamental') or current_user.has_role?('direcao_fundamental')  )
                                w1=current_user.unidade_id
                                w2=current_user.professor_id
                                if session[:disciplina_id]=='--Todas--'

                                      #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                      t=0
                                 else if current_user.has_role?('professor_fundamental')
                                        if current_user.unidade_id == 1   # professor da tempo de viver
                                           w1= session[:cont_classe_id]
                                           w3= current_user.professor_id
                                          @faltasalunos = Faltasaluno.find(:all, :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ?  AND professor_id=?",  session[:dataI], session[:dataF], session[:cont_classe_id],  current_user.professor_id] , :order => 'classe_id ASC')
                                          @faltasalunosddias= Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ?  AND professor_id=?",  session[:dataI], session[:dataF], session[:cont_classe_id],  current_user.professor_id] , :order => 'classe_id ASC')
@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                                          #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                          #? @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                                        else
                                           w1= session[:cont_classe_id]
                                           w2=session[:disciplina_id]
                                           w3= current_user.professor_id
                                          @faltasalunos = Faltasaluno.find(:all, :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id=? AND professor_id=?", session[:dataI], session[:dataF],session[:cont_classe_id], session[:disciplina_id],  current_user.professor_id] , :order => 'classe_id ASC')
                                          @faltasalunosdiasT = Faltasaluno.find(:all, :select=>  'distinct(data) ,aluno_id, 	matricula_id, 	atribuicao_id, 	classe_id, 	professor_id,  	disciplina_id , 	ano_letivo  ', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id=? AND professor_id=?", session[:dataI], session[:dataF],session[:cont_classe_id], session[:disciplina_id],  current_user.professor_id] , :order => 'classe_id ASC')
                                          @faltasalunosdias = Faltasaluno.find(:all, :select=>  'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id=? AND professor_id=?", session[:dataI], session[:dataF],session[:cont_classe_id], session[:disciplina_id],  current_user.professor_id] , :order => 'classe_id ASC')
                                          @faltasalunos_total
t=0

@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , matriculas.classe_num , alunos.aluno_nome	 ,CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
                                          #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                          #? @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
   
                                      end
                                       else   #professor infantis
                                        @faltasalunos = Faltasaluno.find(:all, :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id=?",  session[:dataI], session[:dataF], session[:cont_classe_id],session[:disciplina_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id=?",  session[:dataI], session[:dataF], session[:cont_classe_id],session[:disciplina_id]] , :order => 'inicio DESC, classe_id ASC')
@alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:cont_classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
t=0
                                        #? @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        #? @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                                      end
                                end
                             end
                         end

                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'faltas'
                        end
                      end
             end
        end
    end

end

end