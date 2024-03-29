class AtribuicaosController < ApplicationController

    before_filter :load_professors
    before_filter :load_classes


    def index
        @atribuicaos = Atribuicao.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @atribuicaos }
        end
    end



 def  importar_aula_1bim
    t=0
end




    def show
      t=0
        @atribuicao = Atribuicao.find(params[:id])
         respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @atribuicao }
        end
    end

    def show_editar

        @atribuicao = Atribuicao.find(session[:atribuicao])

    end


    def new
        @atribuicao = Atribuicao.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @atribuicao }
        end
    end


    def edit

        if session[:flag_edit_atribuicao] == 1
            @atribuicao_anterior = Atribuicao.find(:all, :conditions=>['id =?', (params[:id])])

            session[:disciplina_id]=  @atribuicao_anterior[0].disciplina_id
            session[:disciplina_nome]=  @atribuicao_anterior[0].disciplina.disciplina
            session[:professora_id]=  @atribuicao_anterior[0].professor_id
            session[:professor_nome]=  @atribuicao_anterior[0].professor.nome
            @atribuicao = Atribuicao.find(params[:id])


        else
            @atribuicao = Atribuicao.find(params[:id])
            @notas = Nota.find(:all, :conditions => ["atribuicao_id = ? AND aluno_id = ? AND notas.ano_letivo=?", session[:atrib_id],  session[:aluno_id],Time.now.year ])
            if current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('direcao_infantil')
               session[:flag_edit]=1
            end
        end
    end

    def lancar_faltas


            @atribuicao = Atribuicao.find(params[:id])
            #@notas = Nota.find(:all, :conditions => ["atribuicao_id = ? AND aluno_id = ? AND notas.ano_letivo=?", session[:atrib_id],  session[:aluno_id],Time.now.year ])

    end





    def create
        @atribuicao = Atribuicao.new(params[:atribuicao])
        w=session[:classe]= @atribuicao.classe_id
        w1=session[:professor]= @atribuicao.professor_id

        if current_user.unidade_id==1
          session[:disciplina]=@atribuicao.disciplina_id = 106
        else
          session[:disciplina]=@atribuicao.disciplina_id
        end
        @verifica = Atribuicao.find(:all, :select => 'id', :conditions => ['classe_id =? AND professor_id =? AND disciplina_id=? AND ano_letivo=?',@atribuicao.classe_id, @atribuicao.professor_id, @atribuicao.disciplina_id, Time.now.year])

        if @verifica.present? then
            flash[:notice] = 'ESTE PROFESSOR JÁ ESTÁ ATRIBUIDO PARA ESTA CLASSE NESTA DISCIPLINA!'
            respond_to do |format|
                format.html { render :action => "new" }
            end
        else
            respond_to do |format|
                if @atribuicao.save
                    flash[:notice] = 'SALVO COM SUCESSO!'
                    format.html { redirect_to(@atribuicao) }
                    format.xml  { render :xml => @atribuicao, :status => :created, :location => @atribuicao }
                else
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
                end
            end
        end
    end


    def create_observacao_historico

        params[:observacao_historico]
        @observacao_historico = ObservacaoHistorico.new(params[:observacao_historico])
        params[:observacao_historico]

        @historico_aluno  = Aluno.find(session[:historico_aluno_id])
        @observacao_historico.aluno_id = @aluno.id
        params[:id]
        @observacao_historico.data = Time.now

        if @observacao_historico.save

            render :update do |page|
                page.replace_html 'dados', :partial => "observacoes"
                page.replace_html 'edit'
            end
        end

    end



    def update
        @atribuicao = Atribuicao.find(params[:id])
          if session[:faltas_up]!= 1
                if session[:flag_edit_atribuicao] == 1
                   session[:atribuicao]=params[:id]
                   respond_to do |format|
                        if @atribuicao.update_attributes(params[:atribuicao])
                            @notas = Nota.find(:all, :conditions=> ['atribuicao_id=? and disciplina_id=?', @atribuicao.id, session[:disciplina_id]])
                            for nota in @notas
                                nota = Nota.find(nota.id)
                                nota.disciplina_id=@atribuicao.disciplina_id
                                nota.professor_id=@atribuicao.professor_idvoltar_lancamento_faltas
                                nota.save
                            end
                            flash[:notice] = 'Atribuição atualizada.'
                            format.html { redirect_to( show_editar_path ) }
                            format.xml  { head :ok }
                        else
                            format.html { render :action => "edit" }
                            format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
                        end

                    end
                else
                    @outras_atribuicaos = Atribuicao.find(:all, :conditions => ["classe_id =? and professor_id=? and ano_letivo=? " , @atribuicao.classe_id, @atribuicao.professor_id, Time.now.year])
                    respond_to do |format|
                        if @atribuicao.update_attributes(params[:atribuicao])
                            @notas = Nota.find(:all, :conditions => ["atribuicao_id = ? AND ano_letivo=?", @atribuicao.id,Time.now.year ])
                            for nota in @notas
                                nota = Nota.find(nota.id)
                                nota.aulas1=@atribuicao.aulas1
                                nota.aulas2=@atribuicao.aulas2
                                nota.aulas3=@atribuicao.aulas3
                                nota.aulas4=@atribuicao.aulas4
                                nota.aulas5=@atribuicao.aulas1 + @atribuicao.aulas2 + @atribuicao.aulas3 + @atribuicao.aulas4
                                #nota.ac5 = nota.ac1+nota.ac2+nota.ac3+nota.ac4
                                nota.save
                            end
                            if  session[:flag_edit]== 1
                                if ((@atribuicao.aulas1 < 1 ))
                                    format.html { redirect_to(aviso_atribuicaos_path) }
                                    format.xml  { head :ok }
                                else
                                    flash[:notice] = 'SALVO COM SUCESSO!'
                                    format.html { redirect_to(voltar_lancamento_notas_path)}
                                end
                            else
                                if ((@atribuicao.aulas1 < 1 ))
                                    format.html { redirect_to(aviso_atribuicaos_path) }
                                    format.xml  { head :ok }
                                else
                                    flash[:notice] = 'SALVO COM SUCESSO!'
                                    format.html { redirect_to(@atribuicao) }
                                    format.xml  { head :ok }
                                end
                            end
                        else
                            format.html { render :action => "edit" }
                            format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
                        end
                    end
                end
          else
              respond_to do |format|
                  if @atribuicao.update_attributes(params[:atribuicao])
                     flash[:notice] = 'SALVO COM SUCESSO!'
                     format.html { redirect_to(voltar_lancamento_faltas_path)}
                  else
                     format.html { render :action => "edit" }
                     format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
                  end
               end


            session[:faltas_up]= 0
          end
        session[:flag_edit_atribuicao]=0
        session[:flag_edit_atribuicao]=0
        session[:flag_edit]=0
    end





    def destroy
         w=session[:atri_id]=params[:id]
         t=0
         #@notas = Nota.find(:all, :conditions => ["atribuicao_id = ? AND ano_letivo=?",params[:id],Time.now.year ])
         @conteudoR = Conteudo.find(:all, :conditions => ["atribuicao_id = ? AND ano_letivo=?",params[:id],Time.now.year ])
         @conteudosP = Conteudoprogramatico.find(:all, :conditions => ["atribuicao_id = ? AND ano_letivo=?",params[:id],Time.now.year ])
         @conteudos=@conteudosP+@conteudoR
t=0
        if        @conteudos.empty? 
          t=0
            @atribuicao = Atribuicao.find(params[:id])
            @atribuicao.destroy
t=0
            respond_to do |format|
                format.html { redirect_to(home_path) }
                format.xml  { head :ok }
              end
        else
          t=0
           respond_to do |format|
                format.html { redirect_to(aviso_exclusao_path) }
                format.xml  { head :ok }
              end
        end
    end

def aviso_exclusao
  
end



    def consulta_classe_nota
        @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
        for dis in @disci
            disc_id = dis.id
        end
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], disc_id])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], disc_id])
        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_classe'
        end
    end

    def lancar_notas
    end


    def lancar_notas_alunos_atribuicaos
        if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            session[aulas_disciplina]=params[:disciplina]
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])

            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=? AND notas.ativo=1",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
            @alunos3 = Aluno.find(:all, :joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]], :order => 'aluno_nome')
            render :update do |page|
                page.replace_html 'notas', :partial => 'notas'
            end
        end
    end


    def create_notas
        n=(params[:nota])
        @nota = Nota.new(params[:nota])
        @nota.ano_letivo =  Time.now.year
        @nota.bimestre = 1
        @nota.atribuicao_id= session[:id]
        @nota.professor_id= session[:professor_id]
        @nota.unidade_id= current_user.unidade_id
        session[:aluno_id] = @nota.aluno_id
        @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  session[:classe_id], session[:professor_id], session[:disc_id]])
        if @nota.save
            @nota = Nota.all(:conditions => ["atribuicao_id =? AND aluno_id =?", session[:id], session[:aluno_id]])
            t=0
            session[:nota_id] = @nota.id
            render :update do |page|
                page.replace_html 'notas_aluno', :partial => "notas"
            end
        end
    end

    def relatorio_aluno_nome
        session[:ano_nota]= Time.now.year
        @aluno = Aluno.find(:all,:conditions =>['id = ?', params[:aluno_aluno_id]])
        session[:aluno] =params[:aluno_aluno_id]
        if  current_user.has_role?('SEDUC') or current_user.has_role?('supervisao')or current_user.has_role?('admin')
           @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and ano_letivo=?', session[:aluno], session[:ano_nota]])
        else
           @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and ano_letivo=? and unidade_id=?', session[:aluno], session[:ano_nota], current_user.unidade_id])
        end
        t0=0
        @matriculas.each do |matricula|
            session[:classe]=matricula.classe_id
            session[:num]=matricula.classe_num
            session[:status]=matricula.status
            session[:matricula_id]= matricula.id
            session[:un_nome]=matricula.unidade.nome
            session[:un_end]=matricula.unidade.endereco
            session[:un_end_nr]=matricula.unidade.num
            session[:un_end_cep]=matricula.unidade.CEP
            session[:un_end_fone]=matricula.unidade.fone
            t0=0
        end

        @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
        @classe.each do |classe|
            session[:unidade]=classe.unidade_id
            session[:classe_id] = classe.id
            session[:num_classe]= classe.classe_classe[0,1].to_i

        end
        @matricula = Matricula.find(:all,:conditions =>['classe_id = ? AND aluno_id=?', session[:classe_id], session[:aluno] ], :order =>'classe_num')
        quantidade = @matricula.count
        if quantidade == 1
            session[:matricula_id]= @matricula[0].id
        else if quantidade == 2
                session[:matricula_id]= @matricula[1].id
            else if quantidade == 3
                    session[:matricula_id]= @matricula[2].id
                else if quantidade == 4
                        session[:matricula_id]= @matricula[3].id
                    end
                end
            end
        end

        
        #@notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND matricula_id=?", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year, session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        #@notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D' and unidade_id =? AND notas.ano_letivo =? AND matricula_id=?", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year, session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' AND notas.ano_letivo =? AND matricula_id=?", params[:aluno_aluno_id], Time.now.year, session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D' AND notas.ano_letivo =? AND matricula_id=?", params[:aluno_aluno_id], Time.now.year, session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notas = @notasB+@notasD
        @observacao2 = ObservacaoNota.find(:all, :conditions =>['aluno_id =? AND ano_letivo =? AND nota_id is ?', session[:aluno], Time.now.year,nil ] )

             @total_mediasN= Nota.find(:all, :select => " atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=? AND disciplinas.curriculo = 'B'",  session[:classe_id]])
             @total_mediasF= Nota.find(:all, :select => " atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=?",  session[:classe_id]])
#            @total_medias= Nota.find(:all, :select => "notas.ano_letivo, atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=?", session[:classe_id] ])
                session[:total_notas1]=0
                session[:total_faltas1]=0
                session[:total_notas2]=0
                session[:total_faltas2]=0
                session[:total_notas3]=0
                session[:total_faltas3]=0
                session[:total_notas4]=0
                session[:total_faltas4]=0
                session[:total_notas5]=0
                session[:total_faltas5]=0
                for i in 0..(@total_mediasN.count-1)
                    session[:total_notas1]=session[:total_notas1]+@total_mediasN[i].nota1.to_i
                    session[:total_notas2]=session[:total_notas2]+@total_mediasN[i].nota2.to_i
                    session[:total_notas3]=session[:total_notas3]+@total_mediasN[i].nota3.to_i
                    session[:total_notas4]=session[:total_notas4]+@total_mediasN[i].nota4.to_i
                    session[:total_notas5]=session[:total_notas5]+@total_mediasN[i].nota5.to_i
                end
                for i in 0..(@total_mediasF.count-1)
                    session[:total_faltas1]=session[:total_faltas1]+@total_mediasF[i].faltas1.to_i
                    session[:total_faltas2]=session[:total_faltas2]+@total_mediasF[i].faltas2.to_i
                    session[:total_faltas3]=session[:total_faltas3]+@total_mediasF[i].faltas3.to_i
                    session[:total_faltas4]=session[:total_faltas4]+@total_mediasF[i].faltas4.to_i
                    session[:total_faltas5]=session[:total_faltas5]+@total_mediasF[i].faltas5.to_i
                end
                session[:total_notas1]=(session[:total_notas1].to_f/@total_mediasN.count.to_f).round(1)
                session[:total_faltas1]=(session[:total_faltas1]/@total_mediasF.count.to_f).round(1)
                session[:total_notas2]=(session[:total_notas2]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas2]=(session[:total_faltas2]/@total_mediasF.count.to_f).round(1)
                session[:total_notas3]=(session[:total_notas3]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas3]=(session[:total_faltas3]/@total_mediasF.count.to_f).round(1)
                session[:total_notas4]=(session[:total_notas4]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas4]=(session[:total_faltas4]/@total_mediasF.count.to_f).round(1)
                session[:total_notas5]=(session[:total_notas5]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas5]=(session[:total_faltas5]/@total_mediasF.count.to_f).round(1)
        render :partial => 'relatorio_aluno'
    end

    def impressao_relatorio_aluno
        @aluno = Aluno.find(:all,:conditions =>['id = ? ', session[:aluno]])
        @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and ano_letivo=? and unidade_id=?', session[:aluno],session[:ano_nota], current_user.unidade_id])

        @classe=Classe.find(:all,:conditions =>['id = ?', session[:classe]])
        @classe.each do |classe|
            session[:unidade]=classe.unidade_id
            session[:classe_id] = classe.id
        end
        @matricula = Matricula.find(:all,:conditions =>['classe_id=? AND aluno_id=?', session[:classe_id], session[:aluno] ], :order =>'classe_num')
        quantidade = @matricula.count
        if quantidade == 1
            session[:matricula_id]= @matricula[0].id
        else if quantidade == 2
                session[:matricula_id]= @matricula[1].id
            else if quantidade == 3
                    session[:matricula_id]= @matricula[2].id
                else if quantidade == 4
                        session[:matricula_id]= @matricula[3].id
                    end
                end
            end
        end
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' AND notas.ano_letivo=? AND matricula_id=?", session[:aluno],  session[:ano_nota], session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D' AND notas.ano_letivo=? AND matricula_id=?", session[:aluno],  session[:ano_nota], session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notas = @notasB+@notasD
        @observacao2 = ObservacaoNota.find(:all, :conditions =>['aluno_id =? AND ano_letivo =? AND nota_id is ?', session[:aluno], session[:ano_nota],nil ] )

        render :layout => "impressao"
    end

    def relatorios_anterior_classe
        #@ano_boletim =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',  :conditions =>["classe_ano_letivo !=?", Time.now.year],:order => 'classe_ano_letivo DESC')
        if params[:type_of].to_i == 1
            session[:aluno] = params[:aluno][:id]
            session[:ano_nota] = params[:ano_letivo1]
            @aluno = Aluno.find(:all,:conditions =>['id = ? ', session[:aluno]])
            @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno],session[:ano_nota] ])

            @matriculas.each do |matricula|
                session[:classe]=matricula.classe_id
                session[:num]=matricula.classe_num
                session[:status]=matricula.status
                session[:matricula_id]= matricula.id

                session[:un_nome]=matricula.unidade.nome
                session[:un_end]=matricula.unidade.endereco
                session[:un_end_nr]=matricula.unidade.num
                session[:un_end_cep]=matricula.unidade.CEP
                session[:un_end_fone]=matricula.unidade.fone
            end
            @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
            t=0
            @classe.each do |classe|
                session[:unidade]=classe.unidade_id
                session[:classe_id] = classe.id
                session[:num_classe]= classe.classe_classe[0,1].to_i
            end
            @matricula = Matricula.find(:all,:conditions =>['classe_id = ? AND aluno_id=?', session[:classe_id], session[:aluno] ], :order =>'classe_num')
            quantidade = @matricula.count

            if quantidade == 1
                session[:matricula_id]= @matricula[0].id
            else if quantidade == 2
                    session[:matricula_id]= @matricula[1].id
                else if quantidade == 3
                        session[:matricula_id]= @matricula[2].id
                    else if quantidade == 4
                            session[:matricula_id]= @matricula[3].id
                        end
                    end
                end
            end
w1=session[:aluno]
w2= session[:ano_nota]
w3= session[:matricula_id]
t=0


            @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", session[:aluno], session[:ano_nota], session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
            @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D' AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", session[:aluno], session[:ano_nota] , session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
            @notas = @notasB+@notasD
            @observacao2 = ObservacaoNota.find(:all, :conditions =>['aluno_id =? AND ano_letivo =? AND nota_id is ?', session[:aluno], session[:ano_nota],nil ] )
             @total_mediasN= Nota.find(:all, :select => " atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=? AND disciplinas.curriculo = 'B'",  session[:classe_id]])
             @total_mediasF= Nota.find(:all, :select => " atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=?",  session[:classe_id]])
#             @total_medias= Nota.find(:all, :select => "notas.ano_letivo, atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=?", session[:classe_id] ])
         if @notasB.empty?
             render :update do |page|
                  page.replace_html 'relatorio', :partial => 'sem_notas'
               end
         else
                session[:total_notas1]=0
                session[:total_faltas1]=0
                session[:total_notas2]=0
                session[:total_faltas2]=0
                session[:total_notas3]=0
                session[:total_faltas3]=0
                session[:total_notas4]=0
                session[:total_faltas4]=0
                session[:total_notas5]=0
                session[:total_faltas5]=0
                for i in 0..(@total_mediasN.count-1)
                    session[:total_notas1]=session[:total_notas1]+@total_mediasN[i].nota1.to_i
                    session[:total_notas2]=session[:total_notas2]+@total_mediasN[i].nota2.to_i
                    session[:total_notas3]=session[:total_notas3]+@total_mediasN[i].nota3.to_i
                    session[:total_notas4]=session[:total_notas4]+@total_mediasN[i].nota4.to_i
                    session[:total_notas5]=session[:total_notas5]+@total_mediasN[i].nota5.to_i
                end
                for i in 0..(@total_mediasF.count-1)
                    session[:total_faltas1]=session[:total_faltas1]+@total_mediasF[i].faltas1.to_i
                    session[:total_faltas2]=session[:total_faltas2]+@total_mediasF[i].faltas2.to_i
                    session[:total_faltas3]=session[:total_faltas3]+@total_mediasF[i].faltas3.to_i
                    session[:total_faltas4]=session[:total_faltas4]+@total_mediasF[i].faltas4.to_i
                    session[:total_faltas5]=session[:total_faltas5]+@total_mediasF[i].faltas5.to_i
                end
                session[:total_notas1]=(session[:total_notas1].to_f/@total_mediasN.count.to_f).round(1)
                session[:total_faltas1]=(session[:total_faltas1]/@total_mediasF.count.to_f).round(1)
                session[:total_notas2]=(session[:total_notas2]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas2]=(session[:total_faltas2]/@total_mediasF.count.to_f).round(1)
                session[:total_notas3]=(session[:total_notas3]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas3]=(session[:total_faltas3]/@total_mediasF.count.to_f).round(1)
                session[:total_notas4]=(session[:total_notas4]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas4]=(session[:total_faltas4]/@total_mediasF.count.to_f).round(1)
                session[:total_notas5]=(session[:total_notas5]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas5]=(session[:total_faltas5]/@total_mediasF.count.to_f).round(1)

               render :update do |page|
                  page.replace_html 'relatorio', :partial => 'relatorio_aluno'
               end
        end
        else if params[:type_of].to_i == 2
                session[:classe_id] = params[:classe][:id]
                session[:ano_nota] = params[:ano_letivo]

                @matriculas = Matricula.find(:all,:conditions =>['classe_id = ? AND (status = "MATRICULADO" or status = "TRANSFERENCIA" or status = "*REMANEJADO")', params[:classe][:id]], :order =>'classe_num')
                @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
                a=session[:num_classe]= @classe[0].classe_classe[0,1].to_i
                t=0
                @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
                @total_mediasN= Nota.find(:all, :select => " atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=? AND disciplinas.curriculo = 'B'",  params[:classe][:id]])
                @total_mediasF= Nota.find(:all, :select => " atribuicaos.classe_id, notas.id, notas.nota1 , notas.faltas1, notas.nota2 , notas.faltas2, notas.nota3 , notas.faltas3, notas.nota4 , notas.faltas4, notas.nota5 , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id", :conditions => ["notas.ativo is NULL AND atribuicaos.classe_id=?",  params[:classe][:id]])
                #@total_medias= Nota.find(:all, :select => "notas.ano_letivo, atribuicaos.classe_id, notas.id, notas.nota5 'nota5' , notas.faltas5",:joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id", :conditions => ["atribuicaos.classe_id=? AND notas.id = 322122",  params[:classe][:id]])
                session[:total_notas1]=0
                session[:total_faltas1]=0
                session[:total_notas2]=0
                session[:total_faltas2]=0
                session[:total_notas3]=0
                session[:total_faltas3]=0
                session[:total_notas4]=0
                session[:total_faltas4]=0
                session[:total_notas5]=0
                session[:total_faltas5]=0
                for i in 0..(@total_mediasN.count-1)
                    session[:total_notas1]=session[:total_notas1]+@total_mediasN[i].nota1.to_i
                    session[:total_notas2]=session[:total_notas2]+@total_mediasN[i].nota2.to_i
                    session[:total_notas3]=session[:total_notas3]+@total_mediasN[i].nota3.to_i
                    session[:total_notas4]=session[:total_notas4]+@total_mediasN[i].nota4.to_i
                    session[:total_notas5]=session[:total_notas5]+@total_mediasN[i].nota5.to_i
                end
                for i in 0..(@total_mediasF.count-1)
                    session[:total_faltas1]=session[:total_faltas1]+@total_mediasF[i].faltas1.to_i
                    session[:total_faltas2]=session[:total_faltas2]+@total_mediasF[i].faltas2.to_i
                    session[:total_faltas3]=session[:total_faltas3]+@total_mediasF[i].faltas3.to_i
                    session[:total_faltas4]=session[:total_faltas4]+@total_mediasF[i].faltas4.to_i
                    session[:total_faltas5]=session[:total_faltas5]+@total_mediasF[i].faltas5.to_i
                end
                session[:total_notas1]=(session[:total_notas1]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas1]=(session[:total_faltas1]/@total_mediasF.count.to_f).round(1)
                session[:total_notas2]=(session[:total_notas2]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas2]=(session[:total_faltas2]/@total_mediasF.count.to_f).round(1)
                session[:total_notas3]=(session[:total_notas3]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas3]=(session[:total_faltas3]/@total_mediasF.count.to_f).round(1)
                session[:total_notas4]=(session[:total_notas4]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas4]=(session[:total_faltas4]/@total_mediasF.count.to_f).round(1)
                session[:total_notas5]=(session[:total_notas5]/@total_mediasN.count.to_f).round(1)
                session[:total_faltas5]=(session[:total_faltas5]/@total_mediasF.count.to_f).round(1)

                render :update do |page|
                    page.replace_html 'relatorio', :partial => 'relatorio_classe'
                end
            end
        end
    end

    def relatorio_classe
        if (params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @classe.each do |classe|
                session[:num_classe]= classe.classe_classe[0,1].to_i
            end
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]])
        end
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @classes }
        end
    end

    #     BOLETIM ESCOLAR   BOLETIM ESCOLAR   BOLETIM ESCOLAR
    def relatorio_aluno_classe

        session[:classe_id] = params[:classe_id]
        session[:ano_nota] = Time.now.year
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ? ', params[:classe_id]], :order =>'classe_num')
        @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe_id]])

        render :partial => 'relatorio_classe'

    end

    def impressao_relatorio_classe
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order =>'classe_num')
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe_id]])
        @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', session[:classe]],:order =>'aluno_nome')

        render :layout => "impressao"
    end


    def relatorio_aluno_professor
        session[:professor_id] = params[:professor_id]
        @professor = Professor.find(:all,:conditions =>['id = ?', params[:professor_id]])
        @classe = Classe.find(:all, :joins => :atribuicaos, :conditions =>['atribuicaos.professor_id = ?', session[:professor_id]])
        @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.professor_id =?", session[:professor_id]])
        @alunos = Aluno.find(:all, :joins => :notas, :conditions =>['notas.professor_id =?', session[:professor_id]])

        render :partial => 'relatorio_professor'

    end

    def impressao_relatorio_professor
        @professor = Professor.find(:all,:conditions =>['id = ?', session[:professor_id]])
        @notas = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.professor_id =? and  notas.unidade_id =? ", session[:professor_id], current_user.unidade_id],:order => 'alunos.aluno_nome ASC')

        render :layout => "impressao"
    end

    def impressao_lancamentos
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
        @notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
        @alunos3 = Aluno.find(:all, :joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]])
        render :layout => "impressao"
    end

    def relatorio_observacoes

        if ( params[:aluno].present?)
            session[:aluno_imp]= params[:aluno]
            session[:ano_imp]=params[:ano_letivo]

            @aluno = Aluno.find(:all,:conditions =>['id = ? AND aluno_status is null', session[:aluno_imp]])
            session[:aluno] =params[:aluno_aluno_id]
            @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno_imp],params[:ano_letivo]])
            @matriculas.each do |matricula|
                session[:classe]=matricula.classe_id
                session[:num]=matricula.classe_num
            end
            @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
            @classe.each do |classe|
                session[:unidade]=classe.unidade_id
            end

            @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", session[:aluno_imp], current_user.unidade_id, session[:ano_imp]],:order =>'disciplinas.ordem ASC ')
            @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", session[:aluno_imp], current_user.unidade_id, session[:ano_imp]],:order =>'disciplinas.ordem ASC ')
            @notas = @notasB+@notasD

            respond_to do |format|
                format.html # index.html.erb
                format.xml  { render :xml => @notas }
            end
        end
    end


    def mapa_de_classe
        session[:classe_id] = params[:classe][:id]
        @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =? AND disciplinas.nao_disciplina != 1 AND atribuicaos.ativo=0', params[:classe][:id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        render :update do |page|
           if params[:type_of].to_i == 1
               page.replace_html 'mapa', :partial => 'mapa1'
          else if params[:type_of].to_i == 2
                   page.replace_html 'mapa', :partial => 'mapa2'
               else if params[:type_of].to_i == 3
                        page.replace_html 'mapa', :partial => 'mapa3'
                    else if params[:type_of].to_i == 4
                               page.replace_html 'mapa', :partial => 'mapa4'
                        else if params[:type_of].to_i == 5
                                    page.replace_html 'mapa', :partial => 'mapa5'
                             end
                        end
                    end
              end
           end
        end
    end

    def mapa_de_classe_anterior

        session[:classe_id] = params[:classe_mapa][:id]
        session[:ano] =  params[:ano_letivo_mapa]
        w=session[:classe_id]
        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        @classe.each do |classe|
           session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        #@atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.ids = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id =?  AND disciplinas.nao_disciplina != 1 AND atribuicaos.ativo=0', session[:classe_id]],:order =>'disciplinas.ordem ASC')

        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')

         render :update do |page|
           if params[:type_of].to_i == 1
               page.replace_html 'mapa', :partial => 'mapa1'
          else if params[:type_of].to_i == 2
                   page.replace_html 'mapa', :partial => 'mapa2'
               else if params[:type_of].to_i == 3
                        page.replace_html 'mapa', :partial => 'mapa3'
                    else if params[:type_of].to_i == 4
                               page.replace_html 'mapa', :partial => 'mapa4'
                        else if params[:type_of].to_i == 5
                                    page.replace_html 'mapa', :partial => 'mapa5'
                             end
                        end
                    end
              end
           end
        end
    end

    def impressao_lencol1
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
#        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  params[:classe][:id]], :order => 'nome')
        #@atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
         @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ?  AND disciplinas.nao_disciplina != 1 AND atribuicaos.ativo=0', session[:classe_id]],:order =>'disciplinas.ordem ASC')
         
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
#        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  params[:classe][:id]],:order =>'matriculas.id ASC')
#        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', params[:classe][:id]],:order =>' matriculas.classe_num')
#        @disciplinas= Disciplina.find(:all)
        render :layout => "impressao"
    end



    def impressao_lencol2
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        #@atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND atribuicaos.ativo=0', session[:classe_id]],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        render :layout => "impressao"
    end



    def impressao_lencol3
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        #@atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND atribuicaos.ativo=0', session[:classe_id]],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        render :layout => "impressao"
    end


    def impressao_lencol4
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        #@atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND atribuicaos.ativo=0', session[:classe_id]],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        render :layout => "impressao"
    end


    def impressao_lencol5
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        #@atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND atribuicaos.ativo=0 ', session[:classe_id]],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        render :layout => "impressao"
    end


    def historico_aluno

        @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno_nome
        end
        @historico_aluno = Aluno.find(session[:aluno_id])
        @unidade = Unidade.find(:all, :conditions => ['id =?', session[:unidade_id]])
        @disciplinas = Disciplina.find(:all, :conditions =>['id < 22'],:order => 'ordem ASC' )
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id],Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')


        render :update do |page|
            page.replace_html 'historico', :partial => 'notas_historico'
        end

    end

    def arquivo_historico

        #  mostando em formato xls o que era em html
        @aluno = Aluno.find(:all, :conditions => ['id =?',session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
        end
        @unidade = Unidade.find(:all, :conditions => ['id =?', session[:unidade_id]])
        @disciplinas = Disciplina.find(:all, :conditions =>['id < 22'],:order => 'ordem ASC' )
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id],Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        respond_to do |format|
            format.xls
        end
    end


    def impressao_historico
        @aluno = Aluno.find(:all, :conditions => ['id =?', session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , session[:aluno_id], Time.now.year])
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], current_user.unidade_id,Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        render :layout => "impressao"
    end


    def download_historico
        send_file("#{RAILS_ROOT}/public/saidas/#{current_user.unidade.nome}_#{session[:aluno_nome]}_#{Date.today.strftime("%Y_%m_%d")}.xls")
    end


    def transferenciaA

    end

    def transferencia_aluno
        session[:aluno_id]=params[:aluno][:aluno_id]
        @aluno = Matricula.find(:all, :conditions => ["aluno_id =? and unidade_id =? and ano_letivo=? AND status <> 'REMANEJADO' AND status <> 'TRANSFERIDO'", params[:aluno][:aluno_id],current_user.unidade_id, Time.now.year])
        @matricula= Matricula.find(:all, :conditions =>["aluno_id=? AND ano_letivo=? AND unidade_id=? AND status <> 'REMANEJADO' AND status <> 'TRANSFERIDO'",params[:aluno][:aluno_id], Time.now.year,  current_user.unidade_id])
        for matricula in @matricula
            session[:classe]= matricula.classe.classe_classe
            session[:unidade_user]= matricula.classe.unidade_id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , params[:aluno][:aluno_id], Time.now.year])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.unidade_id =? AND notas.ativo is null ", session[:aluno_id], session[:unidade_user], Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.unidade_id =? AND notas.ativo is null"  , session[:aluno_id],session[:unidade_user],Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notas = @notasD + @notasB
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_user],Time.now.year],:order =>'disciplinas.ordem ASC ')
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',params[:aluno][:aluno_id]], :order => 'ano_letivo ASC')
        render :update do |page|
            page.replace_html 'transferencia', :partial => 'transferencia'
        end
    end

    def impressao_transferencia_aluno
        #@aluno = Matricula.find(:all, :conditions => ['aluno_id =? and unidade_id =?', session[:aluno_id],current_user.unidade_id])
        @aluno = Matricula.find(:all, :conditions => ["aluno_id =? and unidade_id =? and ano_letivo=? AND status <> 'REMANEJADO' AND status <> 'TRANSFERIDO'", session[:aluno_id],current_user.unidade_id, Time.now.year])
        #@matricula= Matricula.find(:all, :conditions =>["aluno_id=? AND ano_letivo=? AND unidade_id=?",session[:aluno_id], Time.now.year,  current_user.unidade_id])
        for matricula in @aluno
            session[:classe]= matricula.classe.classe_classe
            session[:unidade_user]= matricula.classe.unidade_id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , session[:aluno_id], Time.now.year])
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' AND notas.ano_letivo =? AND notas.unidade_id =?", session[:aluno_id], Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notasB1 = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.unidade_id =?", session[:aluno_id], session[:unidade_user], Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.unidade_id =?"  ,session[:aluno_id],session[:unidade_user],Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notas = @notasB+@notasD
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], current_user.unidade_id,Time.now.year],:order =>'disciplinas.ordem ASC ')
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')

        render :layout => "impressao"
    end



    def reserva_vaga
        @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
        session[:aluno_id]=params[:aluno][:aluno_id]
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , params[:aluno][:aluno_id], Time.now.year])
        render :update do |page|
            page.replace_html 'documento', :partial => 'reserva_vaga'
        end
    end


    def consulta_observacoes
        render  'relatorios_observacoes'

    end

    def consulta_atribuicao

        @classe = Classe.find(:all, :select => 'distinct(classe_classe)', :joins => "INNER JOIN  matriculas  ON  classes.id = matriculas.classe_id" , :conditions =>['classes.unidade_id =? AND matriculas.ano_letivo=?' , current_user.unidade_id, Time.now.year],:order =>'classe_classe ASC ')

    end

    def editar_atribuicao_classe
        session[:classe_id]=params[:atribuicao][:classe_id]
        @classe = Classe.find(:all,:conditions =>['id = ?', params[:atribuicao][:classe_id]])
        @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', params[:atribuicao][:classe_id],0], :order =>'disciplinas.ordem ASC ' )
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:atribuicao][:classe_id]], :order => 'classe_num ASC')

        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_classe'
        end
    end


    def load_professores11
        @professores1 = type_user(current_user.unidade_id)
    end

    def load_professores1
        if  (current_user.unidade_id == 53) or (current_user.unidade_id == 100)
            @professores1 = Professore.find(:all, :conditions =>  ["desligado=0"], :order => 'nome ASC')
        else
            if unit == 99
                @professores1 = Professore.find(:all, :conditions =>  ["desligado=0 and unidade_id is ?", nil], :order => 'nome ASC')
            else
                @professores1 = Professore.find(:all, :conditions =>  ["desligado=0= 0 and unidade_id = ?", unit], :order => 'nome ASC')
            end
        end
    end

    def classes_ano
        if  (current_user.unidade_id == 52) 
            @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ?' , params[:ano_letivo] ], :order => 'classes.classe_classe ASC')
           # a=session[:num_classe]= @classe_ano[0].classe_classe[0,1].to_i
           # t=0
        else
           @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id],  :order => 'classe_classe ASC'    )
           #a=session[:num_classe]= @classe_ano[0].classe_classe[0,1].to_i
           #            t=0
        end
        # @ano_boletim =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',  :conditions =>["classe_ano_letivo !=?", Time.now.year],:order => 'classe_ano_letivo DESC')
        render :partial => 'selecao_classe'
    end

    def mapa_classe_ano
        if  (current_user.unidade_id == 52)
            # @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.*, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ? ' , params[:ano_letivo] ], :order => 'classes.classe_classe ASC')
             @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.*, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ? AND (unidades.tipo_id = 1 OR  unidades.tipo_id = 4 or unidades.tipo_id = 7) ' , params[:ano_letivo] ], :order => 'classes.classe_classe ASC')

        else
           @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id],  :order => 'classe_classe ASC'    )
        end
        w=session[:classe_id]
        t=0
        render :partial => 'selecao_mapa'
    end


    def load_classes

        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @classes = Classe.find(:all, :conditions => ['classe_ano_letivo = ?', Time.now.year], :order => 'classe_classe ASC')
            #@classes_boletim_anterior = Classe.find(:all, :order => 'classe_classe ASC')
            if current_user.professor_id.nil?
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    # Alterei a linha anterior para que o JONAS ID. 62 também fique na condição 24/04/2017 ###ALEX
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id = 26 or id = 27) AND nao_disciplina = 0"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id < 26 or id > 27) AND nao_disciplina = 0"] )
                end

            else
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    # Alterei a linha anterior para que o JONAS ID. 62 também fique na condição 24/04/2017 ###ALEX
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id = 26 or id = 27)AND nao_disciplina = 0"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id != 27 and id !=26) AND nao_disciplina = 0"])
                end
            end
        else
         if current_user.unidade_id == 1
               @classes = Classe.find(:all, :conditions => ['(unidade_id = ? )and classe_ano_letivo = ?  and (id != 3078 or id != 3079 or id != 3080 or id != 3081 or id != 3082)', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
            else
               @classes = Classe.find(:all, :conditions => ['(unidade_id = ? or unidade_id = 52 )and classe_ano_letivo = ?  ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
            end
           # @classes = Classe.find(:all, :conditions => ['(unidade_id = ? or unidade_id = 52 )and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
           t=0
            if current_user.professor_id.nil?
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    # Alterei a linha anterior para que o JONAS ID. 62 também fique na condição 24/04/2017 ###ALEX
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id = 26 or id = 27) AND nao_disciplina = 0"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id < 26 or id > 27) AND nao_disciplina = 0"])
                end

            else
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    # Alterei a linha anterior para que o JONAS ID. 62 também fique na condição 24/04/2017 ###ALEX
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id = 26 or id = 27)"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["(id != 27 and id !=26)"])
                end


            end


        end
    end

    def load_professors

        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @professors = Professor.find(:all, :select => "id, nome", :conditions => 'desligado = 0',:order => 'nome ASC')
            #        @professor_unidade = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
            #        @alunos1 = Aluno.find(:all,:select => "id, aluno_nome",:order => 'aluno_nome ASC' )
            #        @alunosT=Matricula.find(:all,:select=>"alunos.aluno_nome, alunos.id",:joins=> "left join alunos ON alunos.id=matriculas.aluno_id",:conditions=>["matriculas.unidade_id=? AND matriculas.ano_letivo=?",current_user.unidade_id,Time.now.year],:order => 'alunos.aluno_nome ASC')
            #        t=0
            #        @alunos3 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
            #        @alunos_boletim = @alunos1
        else
            @professors = Professor.find(:all,:select => "id, nome", :conditions => ['id = ? AND desligado = 0', current_user.professor_id  ],:order => 'nome ASC')
            #        @professor_unidade = Professor.find(:all, :conditions => ['(unidade_id = ? or unidade_id = 52 or unidade_id = 54 or diversas_unidades = 1) AND desligado = 0   ', (current_user.unidade_id)],:order => 'nome ASC')
            #         @alunos1 = Aluno.find(:all, :select => "id, aluno_nome",:conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )

            #       @alunosT=Matricula.find(:all,:select=>"alunos.aluno_nome, alunos.id, .unidade_id ",:joins=> "left join alunos ON alunos.id=matriculas.aluno_id",:conditions=>["matriculas.unidade_id=? AND matriculas.ano_letivo=?",current_user.unidade_id,Time.now.year],:order => 'alunos.aluno_nome ASC')
            #       t=0
            #       @alunos3 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
            #        @alunos_boletim = @alunos1
        end
    end


    #   def load_disciplinas
    #      if current_user.professor_id.nil?
    #          if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
    #              @disciplinas = Disciplina.find(:all, :conditions => ["curriculo = 'I'"])
    #              @nota=Nota.find(62)
    #          else
    #              @disciplinas = Disciplina.find(:all, :conditions =>  ["curriculo != 'I'AND id !=2"],:order => 'ordem ASC')
    #              @nota=Nota.find(62)
    #          end

    #      else
    #          if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
    #              @disciplinas = Disciplina.find(:all, :conditions => ["curriculo = 'I'"])
    #              @nota=Nota.find(62)
    #          else
    #            @disciplinas = Disciplina.find(:all, :conditions =>  ["curriculo != 'I' AND id !=2"],:order => 'ordem ASC')
    #            @nota=Nota.find(62)
    #          end
    #     end

    # end

    #  def load_iniciais
    #    @ano =   ObservacaoNota.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
    #    @ano_boletim =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo ASC')
    #    # @alunos2 = Aluno.find(:all, :conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
    #  end

    def boletim_anterior
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
           @alunos_boletim=Matricula.find(:all,:select=>"alunos.id, CONCAT(alunos.aluno_nome, ' |  ', date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn",:joins=> "left join alunos ON alunos.id=matriculas.aluno_id",:conditions=>["matriculas.ano_letivo=?", params[:ano_letivo1]],:order => 'alunos.aluno_nome ASC')
        else
         
          @alunos_boletim=Matricula.find(:all,:select=>"alunos.id, CONCAT(alunos.aluno_nome, ' | ', date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn",:joins=> "left join alunos ON alunos.id=matriculas.aluno_id",:conditions=>["matriculas.unidade_id=? AND matriculas.ano_letivo=?",current_user.unidade_id,params[:ano_letivo1]],:order => 'alunos.aluno_nome ASC')
        end

       
        render :partial => 'alunos_boletim_anterior'
    end


   def salvar_email
        session[:email] = params[:atribuicao_email]
        t=session[:email]


        render :partial => 'salvar'

   end
end
