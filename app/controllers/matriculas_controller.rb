class MatriculasController < ApplicationController

    before_filter :load_dados_iniciais

  def index
    @matriculas = Matricula.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matriculas }
    end
  end

  def show
    @matricula = Matricula.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @matricula }
    end
  end

  def new
    @matricula = Matricula.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @matricula }
    end
  end

  def transferencia
  @matricula = Matricula.new

  respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @matricula }
    end

  end

  def edit
    @matricula = Matricula.find(params[:id])
  end

 def edit_saida
    @matricula = Matricula.find(params[:id])
 end

  def edit_saida_seduc
    @matricula = Matricula.find(params[:id])
 end

  def create
  
   if session[:flagnum] == 1
      @matricula = Matricula.new(params[:matricula])

   else
       @matricula_num = Matricula.find(:last, :conditions => ['classe_id =?', params[:matricula][:classe_id]])
       session[:numero]=@matricula_num.classe_num
       @matricula = Matricula.new(params[:matricula])
       @matricula.classe_num = session[:numero]+1
   end
    @matricula.ano_letivo = Time.now.year
    @matricula.unidade_id= current_user.unidade_id
    session[:classe_id]= @matricula.classe_id
    #@notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id ", :conditions => ["atribuicaos.classe_id =? ",  params[:classe][:id]],:order =>'disciplinas.ordem ASC')
     @matricula_anterior = Matricula.find(:last, :conditions => ['aluno_id =?', @matricula.aluno_id])
     if !@matricula_anterior.nil?
         session[:status_anterior] =  @matricula_anterior.status
     end

    respond_to do |format|
      if @matricula.save
        if  @matricula.status == "*REMANEJADO"
            @matricula_anterior.status = "REMANEJADO"
            @matricula_anterior.save
        end
        if  @matricula.status == "TRANSFERENCIA"
            @matricula_anterior.status = "TRANSFERIDO"
            @matricula_anterior.save
        end
       if (@matricula.status != '*REMANEJADO') and (@matricula.status != 'TRANSFERENCIA')
        @atribuicaos = Atribuicao.find(:all, :conditions=> ['classe_id =?',session[:classe_id]])

        for atrib in @atribuicaos
               session[:classe]= atrib.classe_id
               session[:atribuicao]= atrib.id
               session[:professor]= atrib.professor_id
               session[:disciplina]= atrib.disciplina_id
               if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
                    @nota = Nota.new(params[:nota])
                    @nota.aluno_id = @matricula.aluno_id
                    @nota.atribuicao_id= session[:atribuicao]
                    @nota.matricula_id= @matricula.id
                    @nota.professor_id= session[:professor]
                    @nota.unidade_id= current_user.unidade_id
                    @nota.disciplina_id = session[:disciplina]
                    @nota.ano_letivo =  Time.now.year
                    @nota.nota1 = nil
                    @nota.faltas1 = 0
                    @nota.aulas1 = 0
                    @nota.nota2 = nil
                    @nota.faltas2 = 0
                    @nota.aulas2 = 0
                    @nota.nota3 = nil
                    @nota.faltas3 = 0
                    @nota.aulas3 = 0
                    @nota.nota4 = nil
                    @nota.faltas4 = 0
                    @nota.aulas4 = 0
                    @nota.nota5 = nil
                    @nota.faltas5 = 0
                    @nota.aulas5 = 0
                      if @nota.save
                         flash[:notice] = 'DADOS SALVOS COM SUCESSO!'
                      end
               end
        end
        flash[:notice] = 'MATRICULA SALVA COM'
        if @matricula.status.nil?
          @matriculas = Matricula.find(:all, :conditions => ['classe_id =?', session[:classe_id]])
          format.html { render :action => "show_classe" }
        else
           format.html { redirect_to(@matricula) }
           format.xml  { render :xml => @matricula, :status => :created, :location => @matricula }
        end
     end
     if (@matricula.status == '*REMANEJADO') or (@matricula.status == 'TRANSFERENCIA')



        @classe_ant= Classe.find(:all, :joins => "INNER JOIN  matriculas  ON  classes.id=matriculas.classe_id  INNER JOIN alunos ON alunos.id=matriculas.aluno_id", :conditions =>['aluno_id = ?',@matricula.aluno_id])
        for classe_ant in @classe_ant
           w=session[:classe_ant]= classe_ant.id
           w1=session[:unidade_ant_id]= classe_ant.unidade_id

        end
        @atribuicaos_ant = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe_ant]])
        @atribuicao = Atribuicao.find(:all,:conditions =>['classe_id = ?', @matricula.classe_id])
        @notas_ant = Nota.find(:all, :conditions => ['aluno_id = ? AND unidade_id =? AND ano_letivo=?', @matricula.aluno_id, session[:unidade_ant_id], Time.now.year])

             if (!@matricula.classe_id.nil?) then
              if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
                 for atri in @atribuicao
                   @nota = Nota.new(params[:nota])
                   @nota.aluno_id = @matricula.aluno_id
                   @nota.atribuicao_id= atri.id
                   @nota.matricula_id= @matricula.id
                   @nota.professor_id= atri.professor_id
                   @nota.disciplina_id = atri.disciplina_id
                   @nota.unidade_id=  @matricula.unidade_id
                   @nota.disciplina_id= atri.disciplina_id
                   @nota.ano_letivo =  Time.now.year
                    for notas_ant in @notas_ant
                      if atri.disciplina_id == notas_ant.disciplina_id
                        if !notas_ant.nota1.nil?
                           @nota.nota1 = notas_ant.nota1
                        else
                          @nota.nota1 = nil
                        end
                        if !notas_ant.faltas1.nil?
                           @nota.faltas1 = notas_ant.faltas1
                        else
                          @nota.faltas1 = nil
                        end
                        if !notas_ant.nota2.nil?
                           @nota.nota2 = notas_ant.nota2
                        else
                          @nota.nota2 = nil
                        end
                        if !notas_ant.faltas2.nil?
                           @nota.faltas2 = notas_ant.faltas2
                        else
                          @nota.faltas2 = nil
                        end
                        if !notas_ant.nota3.nil?
                           @nota.nota3 = notas_ant.nota3
                        else
                          @nota.nota3 = nil
                        end
                        if !notas_ant.faltas3.nil?
                           @nota.faltas3 = notas_ant.faltas3
                        else
                          @nota.faltas3 = nil
                        end
                        if !notas_ant.nota4.nil?
                           @nota.nota4 = notas_ant.nota4
                        else
                          @nota.nota4 = nil
                        end
                        if !notas_ant.faltas4.nil?
                           @nota.faltas4 = notas_ant.faltas4
                        else
                          @nota.faltas4 = nil
                         end
                     end
                   end
                   @nota.nota5 = nil
                   @nota.faltas5= nil
                   if @nota.save
                        flash[:notice] = 'DADOS SALVOS COM SUCESSO!'
                   end
                 end
              end
        end
        flash[:notice] = 'MATRICULA SALVA COM'

           format.html { redirect_to(@matricula) }
           format.xml  { render :xml => @matricula, :status => :created, :location => @matricula }
  end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @matricula.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @matricula = Matricula.find(params[:id])

    respond_to do |format|
      if @matricula.update_attributes(params[:matricula])
        flash[:notice] = 'Matricula was successfully updated.'
        format.html { redirect_to(@matricula) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @matricula.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @matricula = Matricula.find(params[:id])
    @matricula.destroy

    respond_to do |format|
      format.html {  redirect_to(@matricula)}
      format.xml  { head :ok }
    end
  end

  def show_destroy
    @matricula = Matricula.find(params[:id])
    @matricula.destroy

 end


  def show_classe
    @matriculas = Matricula.find(:all, :conditions => ['aluno_id =?', session[:aluno_id]], :order => 'classe_num')
  end


  def unidade_transferencia

   session[:unidade_ant_id] = Unidade.find_by_nome(params[:matricula_procedencia])
   @alunos = Aluno.find(:all, :conditions =>['unidade_id =? AND aluno_status is null',  session[:unidade_ant_id]], :order => 'aluno_nome')
   @unidade_para = Unidade.find(:all, :conditions => ['id =?', current_user.unidade_id], :order => 'nome ASC')
   @classes = Classe.find(:all, :conditions =>['unidade_id =?',  current_user.unidade_id], :order => 'classe_classe')
   render :partial => 'selecao_alunos'
  end


  def matricula_aluno_classe

      @matricula = Matricula.find(:all, :conditions =>['aluno_id =? AND ano_letivo = ?' ,params[:aluno_id], Time.now.year])
            render :partial => 'classe_aluno'

  end

def alteracao_matricula
       session[:aluno_id]=params[:aluno][:id]
       @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ?', params[:aluno][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end


def consultar_matricula
       session[:aluno_id]=params[:aluno][:id]
       @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ?', params[:aluno][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe_consulta'
       end

end

def matriculas_saidas
       session[:aluno_id]=params[:aluno][:id]

       @matriculas = Matricula.find(:all, :conditions =>['aluno_id = ? AND (status is null OR status = "*REMANEJADO" OR status = "TRANSFERENCIA")', params[:aluno][:id]], :order => 'classe_num ASC')
        render :update do |page|
          page.replace_html 'aluno2', :partial => 'alunos_saida'
       end
end

def matriculas_saidas_seduc
       session[:aluno_id]=params[:aluno][:id]
       @matriculas = Matricula.find(:all, :conditions =>['aluno_id = ? AND (status is null OR status = "*REMANEJADO" OR status = "TRANSFERENCIA")', params[:aluno][:id]], :order => 'classe_num ASC')
        render :update do |page|
          page.replace_html 'aluno1', :partial => 'alunos_saida_seduc'
       end


end



  def load_dados_iniciais
       unidade=  current_user.unidade_id
       @status= SituacaoAluno.find(:all)
       @status_saida= SituacaoAluno.find(:all,:conditions =>['id = 2'])
       if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id > 41 AND id <52'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all,:conditions =>['id = ?', current_user.unidade_id], :order => 'nome ASC')
       else
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id < 41 AND id > 52'], :order => 'nome ASC')
          @unidade_procedencia = Unidade.find(:all, :order => 'nome ASC')
       end

       @alunos = Aluno.find(:all, :conditions => ['aluno_status is null'],:order => 'aluno_nome')
       @alunos1 = Aluno.find_by_sql("SELECT * FROM alunos  WHERE unidade_id= "+unidade.to_s+" AND`id`not in
                       (SELECT matriculas.aluno_id FROM classes INNER JOIN matriculas ON classes.id = matriculas.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")
                        ORDER BY aluno_nome ASC")
       @alunos2 = Aluno.find(:all, :conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
       @alunos3 = Aluno.find(:all, :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id", :conditions =>['alunos.unidade_id=? AND (matriculas.status is null OR matriculas.status = "*REMANEJADO" OR matriculas.status = "TRANSFERENCIA")  ', current_user.unidade_id],:order => 'alunos.aluno_nome')

      @classes = Classe.find(:all, :conditions =>['unidade_id=?', current_user.unidade_id],:order => 'classe_classe')
       if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @classe = Classe.find(:all, :order => 'classe_classe ASC')
        else
            @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        end
  end
end

