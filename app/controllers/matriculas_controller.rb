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

    def new1
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
    def ja_cadastrado
        session[:id] = params[:aluno_id]
        #@verifica = Matricula.find_by_idnome(session[:nome])
        @verifica = Matricula.find(params[:aluno_id])
        if @verifica then
            render :update do |page|
                page.replace_html 'jacadastrado1', :text => 'MATRICULA JÁ CADASTRADA'
                page.replace_html 'jacadastrado2', :text => 'MATRICULA JÁ CADASTRADA'
            end
        end
    end


    def remanejamento
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

    def edit_reprovacao
        session[:id_reprovado]=params[:id]
        @matricula = Matricula.find(params[:id])
        @matricula.reprovado = 1
        respond_to do |format|
            if @matricula.update_attributes(params[:matricula])
               @matricula.save
                flash[:notice] = 'ALUNO REPROVADO'
                    format.html { redirect_to(show_reprovado_path) }
                    format.xml  { head :ok }


            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @matricula.errors, :status => :unprocessable_entity }
            end
        end
    end


    def show_reprovado
    @matricula = Matricula.find(session[:id_reprovado])
   end


    def reprovados_consultar
        session[:aluno_id]=params[:aluno][:id]
        @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ?', params[:aluno][:id]], :order => 'classe_num ASC')
        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_reprovados'
        end
    end


    def consulta_reprovados1
       session[:classe_id]=params[:classe][:id]

       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0], :order =>'disciplinas.ordem ASC ' )
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classeRep'
       end
    end

def matricular

   @alunos_matricula = Aluno.find_by_sql("SELECT a.id, CONCAT(a.aluno_nome, ' | ',date_format(a.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn FROM alunos a WHERE ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND a.unidade_id = "+(current_user.unidade_id).to_s+" AND ( id NOT IN (SELECT m.aluno_id FROM matriculas m WHERE m.ano_letivo = "+(Time.now.year).to_s+" AND m.status != 'ABANDONO')) ORDER BY a.aluno_nome")
   @classes_atual = Classe.find(:all,:select => 'id, classe_classe', :conditions =>['unidade_id =? and  classe_ano_letivo=?',  current_user.unidade_id, Time.now.year], :order => 'classe_classe')

end

def matricular_alunos

    session[:salvar_matricula]= 1
     @alunos=session[:alunosM]

       for aluno in @alunos

           @matricula = Matricula.new

           @matricula.classe_id = session[:classe]
           @matricula.aluno_id = aluno.id
           @matricula.ano_letivo = Time.now.year
           @matricula.save

       end

end


def matricula_aluno
    @alunos_matricula = Aluno.find_by_sql("SELECT a.id, CONCAT(a.aluno_nome, ' | ',date_format(a.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn FROM alunos a WHERE ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND a.unidade_id = "+(current_user.unidade_id).to_s+" AND ( id NOT IN (SELECT m.aluno_id FROM matriculas m WHERE m.ano_letivo = "+(Time.now.year).to_s+" AND m.status != 'ABANDONO')) ORDER BY a.aluno_nome")
   session[:classe_id]=(params[:matricula_classe_id])
     render :partial => 'alunos_matricular'
end

def classe_id
    session[:classe]= params[:matricula_classe_id]
 end

def alunos_matricula
    @alunos=  Aluno.find(params[:aluno_ids])
    w=session[:alunosM] = Aluno.find(params[:aluno_ids], :select => 'id')
    @classe = Classe.find(:all, :conditions =>['id =?', session[:classe]])
    @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', session[:classe],0], :order =>'disciplinas.ordem ASC ' )


end

    def create
        @matricula_anterior = Matricula.new(params[:matricula])
        @matricula_anterior.aluno_id
        params[:matricula][:classe_id]

        @matricula_anterior = Matricula.find(:all, :conditions => ['classe_id =? AND ano_letivo=? AND aluno_id=? AND status != "ABANDONO"',  params[:matricula][:classe_id], Time.now.year, @matricula_anterior.aluno_id])

        @atribuicao= Atribuicao.find(:all,  :conditions => ['classe_id =? AND ano_letivo=?', params[:matricula][:classe_id], Time.now.year])
        if (@matricula_anterior.empty?) or (session[:matricula_transferencia] == 1)
            if !@atribuicao.empty?
                if session[:flagnum] == 1
                    @matricula = Matricula.new(params[:matricula])
                    session[:flagnum] = 0
                else
                    @matricula_num = Matricula.find(:last, :conditions => ['classe_id =?', params[:matricula][:classe_id]])
                    if  @matricula_num.nil?
                        @matricula = Matricula.new(params[:matricula])
                        @matricula.classe_num = 1
                    else
                        session[:numero]=@matricula_num.classe_num
                        @matricula = Matricula.new(params[:matricula])
                        @matricula.classe_num = session[:numero]+1
                    end
                end
                @matricula.ano_letivo = Time.now.year
                @matricula.unidade_id= current_user.unidade_id
                session[:classe_id]= @matricula.classe_id
                #@notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id ", :conditions => ["atribuicaos.classe_id =? ",  params[:classe][:id]],:order =>'disciplinas.ordem ASC')
                @matricula_anterior = Matricula.find(:last, :conditions => ['aluno_id =?', @matricula.aluno_id])
                if @matricula_anterior.present?
                    session[:classe_ant]= @matricula_anterior.classe_id
                    session[:unidade_ant_id]= @matricula_anterior.unidade_id
                end

                if !@matricula_anterior.nil?
                    session[:status_anterior] =  @matricula_anterior.status
                end
                @matricula_anterior_num_aluno = Matricula.find(:last, :conditions => ['classe_id =?', @matricula.classe_id])
                if @matricula_anterior_num_aluno.nil?
                    @matricula.classe_num=1
                else
                    @matricula.classe_num= (@matricula_anterior_num_aluno.classe_num) +1
                end
                respond_to do |format|
                    if @matricula.save
                        @aluno=Aluno.find(:all, :conditions => ['id =?', @matricula.aluno_id])
                        @aluno[0].unidade_id =  current_user.unidade_id
                        @aluno[0].aluno_status = nil
                        @aluno[0].save
                        if !@matricula_anterior.nil?

                            if  @matricula.status == "*REMANEJADO"
                                @matricula_anterior.status = "REMANEJADO"
                                @matricula_anterior.data_transferencia= @matricula.data_transferencia
                                @matricula_anterior.rem_classe_id = @matricula.classe_id
                                @matricula_anterior.save
                            end
                            if  @matricula.status == "TRANSFERENCIA"
                                @matricula_anterior.status = "TRANSFERIDO"
                                @matricula_anterior.data_transferencia= @matricula.data_transferencia
                                @matricula_anterior.transf_unidade_id = @matricula.unidade_id
                                @matricula_anterior.save
                            end
                        end
                        if (@matricula.status != '*REMANEJADO') and (@matricula.status != 'TRANSFERENCIA')
                            @atribuicaos = Atribuicao.find(:all, :conditions=> ['classe_id =?',session[:classe_id]])

                            for atrib in @atribuicaos
                                session[:classe]= atrib.classe_id
                                session[:atribuicao]= atrib.id
                                session[:professor]= atrib.professor_id
                                session[:disciplina]= atrib.disciplina_id
                                if (current_user.unidade_id > 41  and  current_user.unidade_id < 52) or (current_user.unidade_id == 62)
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
                            flash[:notice] = 'MATRICULA SALVA COM SUCESSO'
                            if @matricula.status =="MATRICULADO"
                                @matriculas = Matricula.find(:all, :conditions => ['classe_id =? and ano_letivo =?', session[:classe_id],Time.now.year], :order => 'classe_num ASC')
                                session[:classe_new1]= @matriculas.last.classe.id
                                format.html { render :action => "show_classe" }

                            else
                                format.html { redirect_to(@matricula) }
                                format.xml  { render :xml => @matricula, :status => :created, :location => @matricula }

                            end
                        end
                        if (@matricula.status == '*REMANEJADO') or (@matricula.status == 'TRANSFERENCIA')
                            @atribuicaos_ant = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe_ant]])
                            @matricula.aluno_id
                            @matricula.classe_id
                            @atribuicao = Atribuicao.find(:all,:conditions =>['classe_id = ?', @matricula.classe_id])
                            @notas_ant = Nota.find(:all, :conditions => ['aluno_id = ? AND unidade_id =? AND ano_letivo=?', @matricula.aluno_id, session[:unidade_ant_id], Time.now.year])
                            if (!@matricula.classe_id.nil?) then
                                if (current_user.unidade_id > 41  and  current_user.unidade_id < 52) or (current_user.unidade_id == 62)
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
                                                    @nota.aulas1=atri.aulas1
                                                else
                                                    @nota.faltas1 = 0
                                                    @nota.aulas1=atri.aulas1
                                                end
                                                if !notas_ant.nota2.nil?
                                                    @nota.nota2 = notas_ant.nota2
                                                else
                                                    @nota.nota2 = nil
                                                end
                                                if !notas_ant.faltas2.nil?
                                                    @nota.faltas2 = notas_ant.faltas2
                                                    @nota.aulas2=atri.aulas2
                                                else
                                                    @nota.faltas2 = 0
                                                    @nota.aulas2=atri.aulas2
                                                end
                                                if !notas_ant.nota3.nil?
                                                    @nota.nota3 = notas_ant.nota3
                                                else
                                                    @nota.nota3 = nil
                                                end
                                                if !notas_ant.faltas3.nil?
                                                    @nota.faltas3 = notas_ant.faltas3
                                                    @nota.aulas3=atri.aulas3
                                                else
                                                    @nota.faltas3 = 0
                                                    @nota.aulas3=atri.aulas3
                                                end
                                                if !notas_ant.nota4.nil?
                                                    @nota.nota4 = notas_ant.nota4
                                                else
                                                    @nota.nota4 = nil
                                                end
                                                if !notas_ant.faltas4.nil?
                                                    @nota.faltas4 = notas_ant.faltas4
                                                    @nota.aulas4=atri.aulas4
                                                else
                                                    @nota.faltas4 = 0
                                                    @nota.aulas4=atri.aulas4
                                                end
                                                notas_ant.ativo=1
                                                notas_ant.save

                                            end
                                        end
                                        @nota.nota5 = nil
                                        @nota.faltas5= 0
                                        if @nota.save
                                            flash[:notice] = 'DADOS SALVOS COM SUCESSO!'
                                        end
                                    end
                                end
                            end
                            flash[:notice] = 'SALVO COM SUCESSO'

                            format.html { redirect_to(@matricula) }
                            format.xml  { render :xml => @matricula, :status => :created, :location => @matricula }
                        end
                    else
                        format.html { render :action => "new" }
                        format.xml  { render :xml => @matricula.errors, :status => :unprocessable_entity }
                    end
                end
            else
                respond_to do |format|
                    #flash[:notice] = 'CADASTRADO COM SUCESSO.'
                    format.html { redirect_to(aviso1_matriculas_path) }
                    format.xml  { head :ok }
                end
            end
        else
            respond_to do |format|
                #flash[:notice] = 'CADASTRADO COM SUCESSO.'
                format.html { redirect_to(aviso2_matriculas_path) }
                format.xml  { head :ok }
            end

        end



    end



    def update
        @matricula = Matricula.find(params[:id])
        status=@matricula.status
        respond_to do |format|
            if @matricula.update_attributes(params[:matricula])
                if @matricula.data_transferencia==Date.today
                    @matricula.data_transferencia=nil
                end
                test1=@matricula.status
                t=0
                if @matricula.status.empty?
                    @matricula.status=status
                end
                teste=@matricula.status
                t=0


                @matricula.save

                if session[:saidaT] == 2
                    t=0
                    @aluno=Aluno.find(:all, :conditions => ['id =?', @matricula.aluno_id])
                    @aluno[0].aluno_status =  'TRANSFERIDO'
                    @aluno[0].unidade_anterior = @aluno[0].unidade_id # ###ALEX 31/08/2015 - Para guardar a unidade anterior que o aluno esteve
                    @aluno[0].unidade_id = 52 # ###ALEX 31/08/2015 - Para colocar o aluno transferido para fora em uma unidade neutra
                    @aluno[0].save
                    session[:saidaT] = 0
                end
                if @matricula.status =='ABANDONO'
                    @aluno=Aluno.find(:all, :conditions => ['id =?', @matricula.aluno_id])
                    @aluno[0].aluno_status =  'ABANDONO'
                    @aluno[0].unidade_anterior = @aluno[0].unidade_id
                    @aluno[0].unidade_id = 52
                    @aluno[0].aluno_sexo  = 'MASCULINO'
                    @aluno[0].save

                end



                flash[:notice] = 'SALVO COM SUCESSO'
                if session[:alterar_direcionamento_editar] == 0
                    session[:botao_show] = 0
                    format.html { redirect_to(@matricula) }
                    format.xml  { head :ok }
                    session[:alterar_direcionamento_editar]= 1
                else
                    format.html { render editar_classe_classes_path, :layout => "application"}
                    format.xml  { head :ok }
                    session[:alterar_direcionamento_editar]= 0
                end


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

        @matriculas = Matricula.find(:all, :conditions => ['classe_id =?', session[:classe_id]], :order => 'classe_num')



    end


    def unidade_transferencia
        session[:unidade_ant_id] = Unidade.find_by_nome(params[:matricula_procedencia])
        #@alunos = Aluno.find(:all, :joins =>"inner join matriculas on alunos.id = matriculas.aluno_id and matriculas.status != 'TRANSFERIDO'" , :conditions =>['alunos.unidade_id =? AND alunos.aluno_status is null AND matriculas.ano_letivo =?',  session[:unidade_ant_id], Time.now.year], :order => 'aluno_nome' )
        @alunos = Aluno.find(:all, :select => "alunos.id, CONCAT(alunos.aluno_nome, ' | ', date_format(alunos.aluno_nascimento, '%d/%m/%Y'), ' | ', cl.classe_classe) AS aluno_nome_dtn", :joins =>"inner join matriculas mat on alunos.id=mat.aluno_id LEFT JOIN classes cl on mat.classe_id=cl.id" , :conditions =>['alunos.unidade_id =? AND mat.ano_letivo =?',  session[:unidade_ant_id], Time.now.year], :order => 'alunos.aluno_nome')
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

    def reprovacao
    end

     def reprovacao_aluno
       session[:aluno_id]=params[:aluno][:id]
        @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? AND ano_letivo =?', params[:aluno][:id],Time.now.year ], :order => 'classe_num ASC')
        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_reprovacao'
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
        if params[:type_of].to_i == 1
            session[:saidaT]= 1
            session[:aluno_aluno_id]
            @matriculas = Matricula.find(:all, :conditions =>['aluno_id = ? AND (status = "MATRICULADO" OR status = "*REMANEJADO" OR status = "TRANSFERENCIA")', params[:aluno][:id]], :order => 'classe_num ASC')
            render :update do |page|
                page.replace_html 'aluno1', :partial => 'alunos_saida_seduc'
            end
            @matriculas = Matricula.find(:all, :conditions =>['aluno_id = ? AND (status = "MATRICULADO" OR status = "*REMANEJADO" OR status = "TRANSFERENCIA")', params[:aluno][:id]], :order => 'classe_num ASC')
        else if params[:type_of].to_i == 2
                session[:saidaT] = 2
                @matriculas = Matricula.find(:all, :conditions =>['aluno_id = ? AND (status = "MATRICULADO" OR status = "*REMANEJADO" OR status = "TRANSFERENCIA")', params[:aluno][:id]], :order => 'classe_num ASC')
                render :update do |page|
                    page.replace_html 'aluno1', :partial => 'alunos_saida'
                end
            end

        end
    end



    def matriculas_saidas_seduc
        session[:saidaT]= 1
        session[:aluno_id]=params[:aluno_id]

        @matriculas = Matricula.find(:all, :conditions =>['aluno_id = ? AND (status = "MATRICULADO" OR status = "*REMANEJADO" OR status = "TRANSFERENCIA")', params[:aluno_id]], :order => 'classe_num ASC')
        render :update do |page|
            page.replace_html 'aluno1', :partial => 'alunos_saida_seduc'
        end


    end



    def load_dados_iniciais
        unidade=  current_user.unidade_id
        @status= SituacaoAluno.find(:all)
        @status_transf = SituacaoAluno.find(:all)
        @status_saida= SituacaoAluno.find(:all,:conditions =>['id = 2'])
        if ((current_user.unidade_id > 41  and  current_user.unidade_id < 52) or current_user.unidade_id == 62)
            @unidade_procedencia1 = Unidade.find(:all,:conditions =>['((id > 41 AND id <52) OR id = 62) AND id != ?',current_user.unidade_id ], :order => 'nome ASC')
            @unidade_procedencia = Unidade.find(:all,:conditions =>['id = ?', current_user.unidade_id], :order => 'nome ASC')
        else
            @unidade_procedencia1 = Unidade.find(:all,:conditions =>['((id <= 41 OR id >51) AND id <> 62) AND id != ? ', current_user.unidade_id], :order => 'nome ASC')
            @unidade_procedencia = Unidade.find(:all, :order => 'nome ASC')
        end
        @alunos3 = Aluno.find(:all, :select =>"alunos.id, CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn", :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id", :conditions =>['alunos.unidade_id=? AND (matriculas.status = "MATRICULADO" OR matriculas.status = "*REMANEJADO" OR matriculas.status = "TRANSFERENCIA") AND  matriculas.ano_letivo =?', current_user.unidade_id, Time.now.year],:order => 'alunos.aluno_nome')

        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @classe = Classe.find(:all, :conditions => ['classe_ano_letivo = ? ',  Time.now.year  ], :order => 'classe_classe ASC')

        else
            @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')

        end
    end
end

