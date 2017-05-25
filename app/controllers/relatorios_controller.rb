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

    #@professors = Professor.find(:all, :select => 'nome', :joins => "INNER JOIN atribuicaos ON professors.id = atribuicaos.professor_id INNER JOIN classes ON classes.id = atribuicaos.classes_id", :conditions => ['relatorios.atribuicao_id=?', @relatorio.id])
t=0
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
  end

  # POST /relatorios
  # POST /relatorios.xml
  def create
    @relatorio = Relatorio.new(params[:relatorio])
    @relatorio.ano_letivo =  Time.now.year
    @relatorio.professor_id = session[:professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =?", session[:professor_id] ])
    @relatorio.atribuicao_id= @atribuicao[0].id
    session[:poraluno] = 1
    session[:aluno_imp]= @relatorio.aluno_id
    respond_to do |format|
      if @relatorio.save
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
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =?", session[:professor_id] ])
       render :partial => 'aluno_classe'
  end


  def consulta_relatorio
      @relatorio = Relatorio.find(:all, :conditions => ['aluno_id =?', params[:aluno_id]])



  end

def consulta_relatorios
    if params[:type_of].to_i == 3
        if ( params[:aluno].present?)
            session[:aluno_imp]= params[:aluno]
            session[:ano_imp]=params[:ano_letivo]
            session[:impressao]= 1
            @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?", params[:aluno]])

            session[:poraluno] = 1

            render :update do |page|
               page.replace_html 'relatorio', :partial => "fapea"
           end
      end
    else if params[:type_of].to_i == 1

                 if ( params[:aluno].present?)
                  w=session[:aluno_imp]= params[:aluno1]
                  w1=session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno1], params[:ano_letivo]])
                  session[:impressao]= 1
                  session[:poraluno] = 0
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapea"
                   end
                end
        else  if params[:type_of].to_i == 2
                 if ( params[:aluno].present?)
                  session[:aluno_imp]= params[:aluno]
                  session[:ano_imp]=params[:ano_letivo]
                  @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", params[:aluno], params[:ano_letivo]])
                  render :update do |page|
                     page.replace_html 'relatorio', :partial => "fapea"
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
                    w1=session[:aluno_imp]= params[:aluno1]
                    w=session[:disciplina]=params[:disciplina2]

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
           @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?", session[:aluno_imp]])

          session[:poraluno]=0
      else
         @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =? and ano_letivo =?", session[:aluno_imp], session[:ano_imp]])
      end
     render :layout => "impressao"
  end
  


  def dados
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =?", session[:professor_id] ])

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
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id < 40  OR id >51'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all, :order => 'nome ASC')
         @disciplinas= Disciplina.find(:all, :conditions =>['curriculo =? and ano_letivo =? ', 'I', (Time.now.year)], :order =>'disciplina'  )
       end

       #@alunos = Aluno.find(:all, :conditions => ['aluno_status is null'],:order => 'aluno_nome')
       #@alunos1 = Aluno.find_by_sql("SELECT * FROM alunos  WHERE unidade_id= "+unidade.to_s+" AND`id` NOT IN
       #                (SELECT matriculas.aluno_id FROM matriculas INNER JOIN alunos ON alunos.id = matriculas.aluno_id WHERE matriculas.ano_letivo = "+(Time.now.year).to_s+" AND matriculas.status <> 'TRANSFERIDO' AND alunos.unidade_id = "+unidade.to_s+")
       #                 ORDER BY aluno_nome ASC")

       @alunos2 = Aluno.find(:all, :select => 'id, aluno_nome',:conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
       #@alunos3 = Aluno.find(:all, :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id", :conditions =>['alunos.unidade_id=? AND (matriculas.status = "MATRICULADO" OR matriculas.status = "*REMANEJADO" OR matriculas.status = "TRANSFERENCIA")  ', current_user.unidade_id],:order => 'alunos.aluno_nome')
       if current_user.has_role?('admin')
          @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
             else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
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
