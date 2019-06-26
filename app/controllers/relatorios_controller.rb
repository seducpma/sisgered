class RelatoriosController < ApplicationController
  # GET /relatorios
  # GET /relatorios.xml
   before_filter :load_dados_iniciais
   before_filter :load_consulta_ano

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
    @relatorio.atribuicao_id
    @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? ', @relatorio.atribuicao_id] )
    @classe[0].classe_id

    @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
    w= params[:id]
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

    @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? ', @relatorio.atribuicao_id] )
   
    @classe[0].classe_id
    #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
    @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN relatorios ON professors.id = relatorios.professor_id", :conditions => ['relatorios.id=?', params[:id]])
  end

  # POST /relatorios
  # POST /relatorios.xml
  def create
    @relatorio = Relatorio.new(params[:relatorio])
    @relatorio.ano_letivo =  Time.now.year

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

        if @relatorio.dias_letivos == 0
          session[:faltas]=0
          @relatorio.faltas=0
          @relatorio.frequencia=0
        else
          w4=session[:aulas]=@relatorio.dias_letivos
          if @relatorio.faltas == 0
            @relatorio.frequencia=100
          else
            w2=@relatorio.frequencia = 100-((session[:faltas].to_f / session[:aulas].to_f)*100)
          end
        end
#       w2=@relatorio.frequencia = 100 -((session[:faltas].to_f / session[:aulas].to_f)*100)
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
        @aluno= Matricula.find(:all, :select => 'alunos.id, alunos.aluno_nome',:joins =>:aluno  ,:conditions=>['matriculas.classe_id=? AND (matriculas.status ="MATRICULADO" OR matriculas.status ="TRANSFERENCIA" OR matriculas.status ="*REMANEJADO")', atribuicao.classe_id ], :order => 'alunos.aluno_nome ASC')
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
      if current_user.has_role?('admin') or current_user.has_role?('pedagogo') or current_user.has_role?('direcao_infantil') or current_user.has_role?('SEDUC') or current_user.has_role?('direcao_fudamental') or current_user.has_role?('supervisao')
        @fapea_ano = Relatorio.find(:all, :joins => :aluno, :conditions=> ['ano_letivo =? and alunos.unidade_id=?' , params[:ano_letivo], current_user.unidade_id])
        ###Alex - mudei no SQL de cima para puxar só da unidade, para diminuir a lista neste momento - AlexML - 25/06/19 12:11 - @fapea_ano = Relatorio.find(:all, :conditions=> ['ano_letivo =?' , params[:ano_letivo]])
        @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.aluno_status is null AND ano_letivo=?', params[:ano_letivo] ],:order => 'alunos.aluno_nome ASC')
      else
        @fapea_ano = Relatorio.find(:all, :joins=> :aluno, :conditions=> ['ano_letivo =? and alunos.unidade_id=?' , params[:ano_letivo], current_user.unidade_id])
        if  current_user.has_role?('professor_infantil')
           @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND relatorios.ano_letivo=?', current_user.unidade_id, params[:ano_letivo] ],:order => 'alunos.aluno_nome')
        else
           @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.aluno_status is null AND relatorios.ano_letivo=?',  params[:ano_letivo] ],:order => 'alunos.aluno_nome')
        end
    end
   render :partial => 'selecao_nome'
  end



def consulta_fapea

    if params[:type_of].to_i == 3
        
            session[:aluno_imp]= params[:aluno_fapea]
            session[:ano_imp]=params[:ano_letivo]
            session[:impressao]= 1

            @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?  and ano_letivo=?", params[:aluno_fapea], Time.now.year])
            @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]], :order => ["id DESC"])
            ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? ', @relatorios[0].atribuicao_id] )
            @classe = Atribuicao.find(:all, :joins => :classe, :select=> 'atribuicaos.classe_id, classes.classe_classe', :conditions => ['classe_id=?', @matricula[0].classe_id] )
            ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
            @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
            #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN relatorios ON professors.id = relatorios.professor_id", :conditions => ['relatorios.id=?', params[:id]])

            session[:poraluno] = 1
            render :update do |page|
               page.replace_html 'relatorio', :partial => "fapea"
           end

     
    else if params[:type_of].to_i == 1

                 if ( params[:aluno_fapea1].present?)
                 session[:aluno_imp]= params[:aluno_fapea1]
                 session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]])
                  @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]], :order => ["id DESC"])
                  ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=?', @relatorios[0].atribuicao_id] )
                  @classe = Atribuicao.find(:all, :joins => :classe, :select=> 'atribuicaos.classe_id, classes.classe_classe', :conditions => ['classe_id=?', @matricula[0].classe_id] )
                  ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  session[:impressao]= 1
                  session[:poraluno] = 0
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapea"
                   end
                end
        else  if params[:type_of].to_i == 2
                t=0
                 if ( params[:aluno].present?)
                  session[:aluno_imp]= params[:aluno]
                  session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno], Time.now.year])
                  @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]], :order => ["id DESC"])
                  ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, Time.now.year] )
                  @classe = Atribuicao.find(:all, :joins => :classe, :select=> 'atribuicaos.classe_id, classes.classe_classe', :conditions => ['classe_id=?', @matricula[0].classe_id] )
                  ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapea"
                   end
                end
             end
        end
    end
  
end


def editar

    if params[:type_of].to_i == 3
        if ( params[:aluno_fapea].present?)
            session[:aluno_imp]= params[:aluno_fapea]
            session[:ano_imp]=params[:ano_letivo]
            session[:impressao]= 1
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?", params[:aluno_fapea]])
                  @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? ', @relatorios[0].atribuicao_id] )
                  @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
            session[:poraluno] = 1

            render :update do |page|
               page.replace_html 'relatorio', :partial => "fapeaE"
           end
      end
    else if params[:type_of].to_i == 1
                 if ( params[:aluno_fapea1].present?)
                  session[:aluno_imp]= params[:aluno_fapea1]
                  session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno_fapea1], params[:ano_letivo]])
                  @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, params[:ano_letivo]] )
                  @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
                  session[:impressao]= 1
                  session[:poraluno] = 0

                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapeaE"
                   end
                end
        else  if params[:type_of].to_i == 2
                 if ( params[:aluno].present?)
                  session[:aluno_imp]= params[:aluno]
                  session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno], params[:ano_letivo]])
                  t=0
                  @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, Time.now.year] )
                  @classe[0].classe_id
                  @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
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


  def impressao_fapea
      if session[:poraluno]==1
            @relatorio = Relatorio.find(:last, :conditions => ["aluno_id =?", session[:aluno_imp]])
            @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", session[:aluno_imp], session[:ano_imp]], :order => ["id DESC"])
            session[:relatorio_id]=@relatorio.id
            ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorio.atribuicao_id, Time.now.year] )
            @classe = Atribuicao.find(:all, :joins => :classe, :select=> 'atribuicaos.classe_id, classes.classe_classe', :conditions => ['classe_id=?', @matricula[0].classe_id] )
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
         @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", session[:aluno_imp], session[:ano_imp]])
         @matricula = Matricula.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", session[:aluno_imp], session[:ano_imp]], :order => ["id DESC"])
         ###Alex 26/06/2019 10:27 - Com os PAs deu problema puxou todos porque o ID da classe é 0 - @classe = Atribuicao.find(:all, :select=> 'classe_id', :conditions => ['id=? AND ano_letivo = ? ', @relatorios[0].atribuicao_id, session[:ano_imp]] )
         @classe = Atribuicao.find(:all, :joins => :classe, :select=> 'atribuicaos.classe_id, classes.classe_classe', :conditions => ['classe_id=?', @matricula[0].classe_id])
         ###Alex 26/06/2019 10:20 - Não sei para que é estou comentando - @classe[0].classe_id
         @professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classe_id", :conditions => ['atribuicaos.classe_id=?', @classe[0].classe_id])
      end
     render :layout => "impressao"
  end
  


  def dados
    w=session[:professor_id]
    w1=params[:relatorio_aluno_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? AND ano_letivo=?", session[:professor_id],Time.now.year])
    @aluno = Aluno.find(:all, :conditions => ["id=?", params[:relatorio_aluno_id]])

    render :update do |page|
          page.replace_html 'dados_aluno', :partial => 'dados'
          page.replace_html 'dados_aluno1', :partial => 'dados_pais'
       end
  end

  def load_dados_iniciais
       unidade=  current_user.unidade_id
       if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id > 41 AND id <52'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all,:conditions =>['id = ?', current_user.unidade_id], :order => 'nome ASC')
         @disciplinas= Disciplina.find(:all, :conditions =>['curriculo != "I" and ano_letivo =? ', (Time.now.year)], :order =>'disciplina'  )
       else
         #@alunosRel = Relatorio.find(:all, :select => 'alunos.id, alunos.aluno_nome', :joins => :aluno,  :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null', current_user.unidade_id ],:order => 'alunos.aluno_nome')
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id < 40  OR id >51'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all, :order => 'nome ASC')
         @disciplinas= Disciplina.find(:all, :conditions =>['curriculo =? and ano_letivo =? ', 'I', (Time.now.year)], :order =>'disciplina'  )
       end
       #@alunos = Aluno.find(:all, :conditions => ['aluno_status is null'],:order => 'aluno_nome')
       #@alunos1 = Aluno.find_by_sql("SELECT * FROM alunos  WHERE unidade_id= "+unidade.to_s+" AND`id` NOT IN
       #                (SELECT matriculas.aluno_id FROM matriculas INNER JOIN alunos ON alunos.id = matriculas.aluno_id WHERE matriculas.ano_letivo = "+(Time.now.year).to_s+" AND matriculas.status <> 'TRANSFERIDO' AND alunos.unidade_id = "+unidade.to_s+")
       #                 ORDER BY aluno_nome ASC")

       @alunos2 = Aluno.find(:all, :select => 'alunos.id, alunos.aluno_nome', :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id INNER JOIN classes ON classes.id = matriculas.classe_id INNER JOIN atribuicaos ON classes.id = atribuicaos.classe_id", :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND atribuicaos.professor_id =?', current_user.unidade_id, current_user.professor_id ],:order => 'alunos.aluno_nome')       #@alunos3 = Aluno.find(:all, :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id", :conditions =>['alunos.unidade_id=? AND (matriculas.status = "MATRICULADO" OR matriculas.status = "*REMANEJADO" OR matriculas.status = "TRANSFERENCIA")  ', current_user.unidade_id],:order => 'alunos.aluno_nome')

      
       if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('Supervisão')
          @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
          @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.aluno_status is null'],:order => 'alunos.aluno_nome ASC')
       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
#             @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null', current_user.unidade_id ],:order => 'alunos.aluno_nome')
              #@alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => "INNER JOIN alunos ON alunos.id = relatorios.aluno_id INNER JOIN matriculas ON alunos.id = matriculas.aluno_id INNER JOIN classes ON classes.id = matriculas.classe_id INNER JOIN atribuicaos ON classes.id = atribuicaos.classe_id", :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND atribuicaos.professor_id =?', current_user.unidade_id, current_user.professor_id ],:order => 'alunos.aluno_nome')
              @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => [:professor, :aluno], :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND relatorios.professor_id =?', current_user.unidade_id, current_user.professor_id ],:order => 'alunos.aluno_nome')
              else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil') or    current_user.has_role?('pedagogo')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                   @alunosRel = Relatorio.find(:all, :select => 'distinct(alunos.aluno_nome), alunos.id', :joins => :aluno,  :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null', current_user.unidade_id ],:order => 'alunos.aluno_nome')
                   t=0
                 end
           end
       end
       #@professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')

  end

  def load_consulta_ano
    @ano =   Relatorio.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
    @ano1 =   Nota.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
    @disciplina=  Disciplina.find(:all,:select => 'distinct(disciplina) as disciplina', :conditions => ['ano_letivo =? and tipo_un =?', Time.now.year, 3] ,:order => 'ano_letivo DESC')

  end
end
