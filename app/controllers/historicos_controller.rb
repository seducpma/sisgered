class HistoricosController < ApplicationController

    before_filter :load_professors
    before_filter :load_classes
    before_filter :load_disciplinas
    before_filter :load_iniciais

    def destroy_nota
        @nota = Nota.find(params[:id])
        @nota.destroy
        @aluno = Aluno.find(:all, :select => 'id, aluno_nome, unidade_id, aluno_ra, aluno_nascimento, aluno_certidao_nascimento, aluno_livro, aluno_folha, aluno_naturalidade, aluno_nacionalidade, aluno_chegada_brasil, aluno_RNE, aluno_validade_estrangeiro, aluno_RG, 	aluno_emissaoRG, 	aluno_CPF, 	aluno_emissaoCPF, photo_file_name,	photo_content_type,	photo_file_size',:conditions => ['id =?', session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno_nome
        end
        @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
        @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
        @disciplinasB = Disciplina.find(:all, :conditions =>['curriculo = "B"'],:order => 'ordem ASC' )
        @disciplinasD = Disciplina.find(:all, :conditions =>['curriculo = "D"'],:order => 'ordem ASC' )
        @disciplinas = @disciplinasD + @disciplinasB
        @notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
        @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]])
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5', :conditions => ['aluno_id =? and classe IS NULL AND ano_letivo<?', session[:aluno_id], Time.now.year], :order => 'ano_letivo ASC')
        @ano_final = Nota.find(:last, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        respond_to do |format|
            format.html { redirect_to(historicoContinua_path) }
            format.xml  { head :ok }
        end


    end

    def resultado_final

    end

    def final_resultado
        session[:classe_id]=params[:classe_resultado_final][:id]

        @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe_resultado_final][:id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND ativo=?', params[:classe_resultado_final][:id],0],:order =>'disciplinas.ordem ASC' )
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe_resultado_final][:id]], :order => 'classe_num ASC')
        #@notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? AND notas.ativo is null",  params[:classe_resultado_final][:id]],:order =>'disciplinas.ordem ASC')
        @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', params[:classe_resultado_final][:id]],:order =>' matriculas.classe_num')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')

        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_classe'
        end

    end


    def create_cadastra_disciplina
        @disc=Disciplina.find(:all)
        for disc in @disc
            n_ordem= disc.ordem
        end
        @disciplina = Disciplina.new(params[:disciplina])
        @disciplina.curriculo = 'B'
        @disciplina.tipo_un = 3
        @disciplina.ordem = n_ordem +1
        if @disciplina.save

            @aluno = Aluno.find(:all, :conditions => ['id =?', session[:aluno_id]])
            for aluno in @aluno
                session[:unidade_id]= aluno.unidade_id
                session[:aluno_id]= aluno.id
                session[:aluno_nome] = aluno.aluno_nome
            end
            @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
            @unidade = Unidade.find(:all, :conditions => ['id =?', session[:unidade_id]])
            @disciplinasB = Disciplina.find(:all, :conditions =>['curriculo = "B"'],:order => 'ordem ASC' )
            @disciplinasD = Disciplina.find(:all, :conditions =>['curriculo = "D"'],:order => 'ordem ASC' )
            @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
            @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
            @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5', :conditions => ['aluno_id =? and classe IS NULL AND ano_letivo<?', session[:aluno_id],Time.now.year], :order => 'ano_letivo ASC')
            render :update do |page|
                page.replace_html 'dados_historico', :partial => "notas_historico"
            end
        end

    end

    def create_cadastra_nota
        @nota = Nota.new(params[:nota])
        session[:aluno_id]
        @nota.aluno_id = session[:aluno_id]
        @aluno = Aluno.find(:all, :conditions => ['id =?', session[:aluno_id]])
        for aluno in @aluno
            unidade_id=aluno.unidade_id
        end
        @nota.unidade_id = unidade_id
        if @nota.save
            for aluno in @aluno
                session[:unidade_id]= aluno.unidade_id
                session[:aluno_id]= aluno.id
                session[:aluno_nome] = aluno.aluno_nome
            end
            @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
            @unidade = Unidade.find(:all, :conditions => ['id =?', session[:unidade_id]])
            @disciplinas = Disciplina.find(:all, :conditions =>['curriculo != "I"'],:order => 'ordem ASC' )
            @disciplinasB = Disciplina.find(:all, :conditions =>['curriculo = "B"'],:order => 'ordem ASC' )
            @disciplinasD = Disciplina.find(:all, :conditions =>['curriculo = "D"'],:order => 'ordem ASC' )
            @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
            @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
            @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5', :conditions => ['aluno_id =? and classe IS NULL AND ano_letivo<?', session[:aluno_id], Time.now.year], :order => 'ano_letivo ASC')
            render :update do |page|
                page.replace_html 'dados_historico', :partial => "notas_historico"
            end
        end
    end

    def create_observacao_historico
        @observacao_historico = ObservacaoHistorico.new(params[:observacao_historico])
        @observacao_historico.aluno_id = session[:aluno_id]
        @observacao_historico.ano_letivo = Time.now.year
        if @observacao_historico.save
            @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
            render :update do |page|
                page.replace_html 'dados', :partial => "observacoes"
                page.replace_html 'edit'
            end
        end

    end

    def relatorio_observacoes
        if ( params[:aluno].present?)
            session[:aluno_imp]= params[:aluno]
            session[:ano_imp]=params[:ano_letivo]
            @aluno = Aluno.find(:all,:select=> 'id, aluno_nome' ,:conditions =>['id = ? AND aluno_status is null', session[:aluno_imp]])
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
            @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", session[:aluno_imp], current_user.unidade_id, session[:ano_imp]],:order =>'disciplinas.ordem ASC ')
            @notas = @notasB+@notasD

            respond_to do |format|
                format.html # index.html.erb
                format.xml  { render :xml => @notas }
            end
        end
    end


    def historico
        if  (params[:aluno_id].present?)
            @aluno = Aluno.find(:all, :select => 'id, aluno_nome, aluno_mae, aluno_pai, unidade_id, aluno_ra, aluno_nascimento, aluno_certidao_nascimento, aluno_livro, aluno_folha, aluno_naturalidade, aluno_nacionalidade, aluno_chegada_brasil, aluno_RNE, aluno_validade_estrangeiro, aluno_RG, 	aluno_emissaoRG, 	aluno_CPF, 	aluno_emissaoCPF, photo_file_name,	photo_content_type,	photo_file_size',:conditions => ['id =?', params[:aluno_id]])
            for aluno in @aluno
                session[:unidade_id]= aluno.unidade_id
                session[:aluno_id]= aluno.id
                session[:aluno_nome] = aluno.aluno_nome
            end
            #@matricula_atual= Matricula.find(:last, :joins=>[:classe ,:unidade],:conditions =>['matriculas.aluno_id=? AND classes.classe_ano_letivo= ?',  session[:aluno_id], Time.now.year])
            #@tipo_unidade=Unidade.find(:all, :conditions=> ["id=?",@matricula_atual.unidade_id])
            @tipo_unidade=Unidade.find(:all, :conditions=> ["id=?",@aluno[0].unidade_id])
            @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
            @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
            # @disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
            #@disciplinasB1 = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" AND (ordem_curriculo =10 or ordem_curriculo =11  or ordem_curriculo =12) ) ORDER BY ordem_curriculo ASC")
            #@disciplinasB2 = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" AND ordem_curriculo =13)  ORDER BY ordem_curriculo ASC")
            #@disciplinasB3 = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" AND (ordem_curriculo =14 or ordem_curriculo =15  or ordem_curriculo =16   or ordem_curriculo =17)) ORDER BY ordem_curriculo ASC")
            #@disciplinasB4 = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" AND ordem_curriculo =18)  ORDER BY ordem_curriculo ASC")
            @disciplinasB  = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"'")
            @disciplinasB1 = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=10 AND di.ordem_curriculo<=19) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")
            @disciplinasB2 = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=20 AND di.ordem_curriculo<=29) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")
            @disciplinasB3 = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=30 AND di.ordem_curriculo<=39) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")
            @disciplinasB4 = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=40 AND di.ordem_curriculo<=49) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")
            @disciplinasD1 = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=70 AND di.ordem_curriculo<=79) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")

            #@disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
            ###Alex 05-02-2020-Cópia segurança Alex @disciplinasD = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND notas.ano_letivo<'"+Time.now.year.to_s+"'")
            @disciplinasD  = Nota.find_by_sql("SELECT DISTINCT di.disciplina, notas.disciplina_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")
            @notasB        = Nota.find_by_sql("SELECT notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND notas.ativo is NULL ORDER BY notas.disciplina_id, notas.ano_letivo")
            @notasB1       = Nota.find_by_sql("SELECT notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=10 AND di.ordem_curriculo<=19) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")
            @notasB2       = Nota.find_by_sql("SELECT notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=20 AND di.ordem_curriculo<=29) AND notas.ativo is NULL ORDER BY di.ordem_curriculo , notas.disciplina_id, notas.ano_letivo")
            @notasB3       = Nota.find_by_sql("SELECT notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=30 AND di.ordem_curriculo<=39) AND notas.ativo is NULL ORDER BY di.ordem_curriculo,  notas.disciplina_id, notas.ano_letivo")
            @notasB4       = Nota.find_by_sql("SELECT notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND (di.ordem_curriculo>=40 AND di.ordem_curriculo<=49) AND notas.ativo is NULL ORDER BY di.ordem_curriculo , notas.disciplina_id, notas.ano_letivo")
            @notasD        = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND notas.ativo is NULL ORDER BY notas.disciplina_id, notas.ano_letivo")
            @notasD1       = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND notas.ativo is NULL AND (di.ordem_curriculo>=70 AND di.ordem_curriculo<=79) ORDER BY di.ordem_curriculo , notas.disciplina_id, notas.ano_letivo")
            session[:contnotaBTot] =(@notasB.count)
            session[:contnotaBTot1]=(@notasB1.count)
            session[:contnotaBTot2]=(@notasB2.count)
            session[:contnotaBTot3]=(@notasB3.count)
            session[:contnotaBTot4]=(@notasB4.count)
            session[:contnotaDTot] =(@notasD.count)
            session[:contnotaDTot1]=(@notasD1.count)
            @disciplinas = @disciplinasD + @disciplinasB
            @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
            #@matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]])
#            @matricula = Matricula.find(:last, :joins => [:notas], :conditions => ["(matriculas.aluno_id = ?) AND (matriculas.reprovado='0' OR notas.matricula_id IS NULL) AND (matriculas.status='MATRICULADO' OR matriculas.status='TRANSFERENCIA' OR matriculas.status='*REMANEJADO' OR notas.matricula_id is NULL)", session[:aluno_id]])
            @notas_por = Nota.find_by_sql("SELECT notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM notas JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id LEFT JOIN atribuicaos at ON at.id=notas.atribuicao_id LEFT JOIN classes cl ON cl.id=at.classe_id WHERE notas.disciplina_id=1 AND notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND notas.ativo is NULL ORDER BY notas.disciplina_id DESC, notas.ano_letivo DESC")
            i=0
            while (i<@notas_por.count) do
                if !(@notas_por[i].nota5).nil?
                    @matricula=Nota.find_by_sql("SELECT ma.id 'matr_id', notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5 FROM notas JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id LEFT JOIN atribuicaos at ON at.id=notas.atribuicao_id LEFT JOIN classes cl ON cl.id=at.classe_id WHERE notas.matricula_id="+@notas_por[i].matricula_id.to_s+" AND notas.disciplina_id=1 AND notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) AND notas.ativo is NULL ORDER BY notas.disciplina_id DESC, notas.ano_letivo DESC")
                    session[:matr_id]=@matricula[0].matr_id
                    @matricula=Matricula.find(@matricula[0].matr_id)
                    i=@notas_por.count
                end
            end
t0=0
            session[:ult_cl_rede]=@matricula.classe.classe_classe[0,1].to_i
            session[:ult_cl_rede_per]=@matricula.classe.horario
session[:id_classe_teste]=(@matricula.classe.id).to_s+" | "+@matricula.classe.classe_classe+" | "+@matricula.classe.horario
            if session[:ult_cl_rede]<6
                session[:ult_coluna]=4
            else
                session[:ult_coluna]=8
            end
            @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =? and classe is null',session[:aluno_id]], :order => 'ano_letivo ASC')
            @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5, classe', :conditions => ['aluno_id =? AND ano_letivo<?', session[:aluno_id],Time.now.year], :order => 'ano_letivo ASC')
            session[:ano]= @ano_inicial.ano_letivo
            session[:classe]= @ano_inicial.classe
        end
    end

    def historicoContinua
        @aluno = Aluno.find(:all, :select => 'id, aluno_nome, unidade_id, aluno_ra, aluno_nascimento, aluno_certidao_nascimento, aluno_livro, aluno_folha, aluno_naturalidade, aluno_nacionalidade, aluno_chegada_brasil, aluno_RNE, aluno_validade_estrangeiro, aluno_RG, 	aluno_emissaoRG, 	aluno_CPF, 	aluno_emissaoCPF, photo_file_name,	photo_content_type,	photo_file_size',:conditions => ['id =?', session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno_nome
        end
        @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
        @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
        @disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @notasB = Nota.find_by_sql("SELECT notas.unidade_id, notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        @notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        #  Comentado abaixo para ser excluído caso não se ache necessidade alguma das linhas 31/10/2017 ###Alex
        #@carga_horaria=ObservacaoHistorico.find(:all, :conditions => ["ano_letivo =? AND aluno_id=? AND carga_horaria_d IS NOT NULL", 2015, session[:aluno_id]])
        session[:contnotaBTot]=(@notasB.count)
        session[:contnotaDTot]=(@notasD.count)
        @disciplinas = @disciplinasD + @disciplinasB
        #  Comentado abaixo para ser excluído caso não se ache necessidade alguma das linhas 31/10/2017 ###Alex
        #@notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
        @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id], Time.now.year], :order => 'notas.ano_letivo ASC')
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =? and classe is null',session[:aluno_id]], :order => 'ano_letivo ASC')
        @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5, classe', :conditions => ['aluno_id =? AND notas.ano_letivo<?', session[:aluno_id], Time.now.year], :order => 'ano_letivo ASC')
        session[:ano]= @ano_inicial.ano_letivo
        session[:classe]= @ano_inicial.classe
        #  Comentado abaixo para ser excluído caso não se ache necessidade alguma das linhas 31/10/2017 ###Alex
        #@ano_final = Nota.find(:last, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')

=begin Comentado para colar o conteúdo inteiro da "def historico" para cá e ver se funciona normalmente
        @aluno = Aluno.find(:all, :select => 'id, aluno_nome, unidade_id, aluno_ra, aluno_nascimento, aluno_certidao_nascimento, aluno_livro, aluno_folha, aluno_naturalidade, aluno_nacionalidade, aluno_chegada_brasil, aluno_RNE, aluno_validade_estrangeiro, aluno_RG, 	aluno_emissaoRG, 	aluno_CPF, 	aluno_emissaoCPF, photo_file_name,	photo_content_type,	photo_file_size',:conditions => ['id =?', session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno_nome
        end
        @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
        @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
        @disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")

        @notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        #  Comentado abaixo para ser excluído caso não se ache necessidade alguma das linhas 31/10/2017 ###Alex
        #@carga_horaria=ObservacaoHistorico.find(:all, :conditions => ["ano_letivo =? AND aluno_id=? AND carga_horaria_b IS NOT NULL", 2015, session[:aluno_id]])
        #@notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id  WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B'  ORDER BY notas.disciplina_id, notas.ano_letivo")
        @notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO'OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        #@notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id  WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D'  ORDER BY notas.disciplina_id, notas.ano_letivo")
        session[:contnotaBTot]=(@notasB.count)
        session[:contnotaDTot]=(@notasD.count)
        @disciplinas = @disciplinasD + @disciplinasB
        #  Comentado abaixo para ser excluído caso não se ache necessidade alguma das linhas 31/10/2017 ###Alex
        #@notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
        @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =? and classe is null',session[:aluno_id]], :order => 'ano_letivo ASC')
        @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5', :conditions => ['aluno_id =? and classe IS NULL', session[:aluno_id]], :order => 'ano_letivo ASC')
        @ano_final = Nota.find(:last, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
=end
    end


    def classes_ano
        @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id], :order => 'classe_classe ASC')
        render :partial => 'selecao_classe'
    end

    def impressao_nota_final

        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        #@atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?',session[:classe_id],0])
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0],:order =>'disciplinas.ordem ASC' )
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
        #@notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? AND notas.ativo is null", session[:classe_id]],:order =>'disciplinas.ordem ASC')
        @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?',session[:classe_id]],:order =>' matriculas.classe_num')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
     
        render :layout => "impressao"

    end

    def impressao_historico
        @aluno = Aluno.find(:all, :select => 'id, aluno_nome, unidade_id, aluno_ra, aluno_nascimento, aluno_certidao_nascimento, aluno_livro, aluno_folha, aluno_naturalidade, aluno_nacionalidade, aluno_chegada_brasil, aluno_RNE, aluno_validade_estrangeiro, aluno_RG, 	aluno_emissaoRG, 	aluno_CPF, 	aluno_emissaoCPF, photo_file_name,	photo_content_type,	photo_file_size',:conditions => ['id =?', session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno_nome
        end
        @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
        @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
        @disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        @notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND notas.ano_letivo<'"+Time.now.year.to_s+"' AND (ma.reprovado='0' OR notas.matricula_id IS NULL) AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        #  Comentado abaixo para ser excluído caso não se ache necessidade alguma das linhas 31/10/2017 ###Alex
        #@carga_horaria=ObservacaoHistorico.find(:all, :conditions => ["ano_letivo =? AND aluno_id=? AND carga_horaria_d IS NOT NULL", 2015, session[:aluno_id]])
        session[:contnotaBTot]=(@notasB.count)
        session[:contnotaDTot]=(@notasD.count)
        @disciplinas = @disciplinasD + @disciplinasB
        #  Comentado abaixo para ser excluído caso não se ache necessidade alguma das linhas 31/10/2017 ###Alex
        #@notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
        @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =? and classe is null',session[:aluno_id]], :order => 'ano_letivo ASC')
        @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5, classe', :conditions => ['aluno_id =? AND ano_letivo<?', session[:aluno_id], Time.now.year], :order => 'ano_letivo ASC')
        session[:ano]= @ano_inicial.ano_letivo
        session[:classe]= @ano_inicial.classe
        w=@notas_ano = Nota.find(:last, :joins => "left JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id left JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? and notas.atribuicao_id is not null and  notas.matricula_id is not null",  session[:aluno_id], session[:unidade_id_port]])
        t=0
        render :layout => "impressao"
    end
=begin Comentado para colar o conteúdo inteiro da "def historico" para cá e ver se funciona normalmente
        w4=session[:aluno_id]
        @aluno = Aluno.find(:all, :select => 'id, aluno_nome, unidade_id, aluno_ra, aluno_nascimento, aluno_certidao_nascimento, aluno_livro, aluno_folha, aluno_naturalidade, aluno_nacionalidade, aluno_chegada_brasil, aluno_RNE, aluno_validade_estrangeiro, aluno_RG, 	aluno_emissaoRG, 	aluno_CPF, 	aluno_emissaoCPF, photo_file_name,	photo_content_type,	photo_file_size',:conditions => ['id =?',session[:aluno_id] ])
        for aluno in @aluno
            session[:unidade_id]=aluno.unidade_id
            session[:aluno_id]=aluno.id
            session[:aluno_nome]=aluno.aluno_nome
        end
        @historico_aluno=ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
        @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
        #@disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina,  notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' or notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")

        @notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina,  notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")


        session[:contnotaBTot]=(@notasB.count)
        session[:contnotaDTot]=(@notasD.count)
        @disciplinas = @disciplinasD + @disciplinasB
        #@notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
        @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?',session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =? and classe is null',session[:aluno_id]], :order => 'ano_letivo ASC')
        @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5', :conditions => ['aluno_id =? and classe IS NULL', session[:aluno_id]], :order => 'ano_letivo ASC')
        session[:ano]= @ano_inicial.ano_letivo
        session[:classe]= @ano_inicial.classe
        @ano_final = Nota.find(:last, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        if (session[:unidade_id]!=current_user.unidade_id)
            session[:unidade_id]=current_user.unidade_id
        end
        @notas_ano = Nota.find(:last, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? ",  session[:aluno_id], session[:unidade_id]])
        render :layout => "impressao"
=end Comentado para colar o conteúdo inteiro da "def historico" para cá e ver se funciona normalmente


    def apagar__nao_serve_para_nada
        @aluno = Aluno.find(:all, :conditions => ['id =?',  session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno_nome
        end
        @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
        @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
        @disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO') ORDER BY notas.disciplina_id, notas.ano_letivo")
        @notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO') ORDER BY notas.disciplina_id, notas.ano_letivo")
        session[:contnotaBTot]=(@notasB.count)
        session[:contnotaDTot]=(@notasD.count)
        @disciplinas = @disciplinasD + @disciplinasB
        #@notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
        @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        @anos_letivos = Nota.find(:all, :select => 'id, ano_letivo, matricula_id, nota5', :conditions => ['aluno_id =? and classe IS NULL and ano_letivo<?', session[:aluno_id], Time.now.year], :order => 'ano_letivo ASC')
        @ano_final = Nota.find(:last, :conditions => ['aluno_id =? and classe is null',session[:aluno_id]], :order => 'ano_letivo ASC')
        @notas_ano = Nota.find(:last, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? ",  session[:aluno_id], session[:unidade_id]])
     
     
        #@ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        render :layout => "impressao"
    end


    def download_historico
        send_file("#{RAILS_ROOT}/public/saidas/#{current_user.unidade.nome}_#{session[:aluno_nome]}_#{Date.today.strftime("%Y_%m_%d")}.xls")
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


    def load_classes
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @classes = Classe.find(:all, :conditions => ['classe_ano_letivo = ?', Time.now.year], :order => 'classe_classe ASC')
            if current_user.professor_id.nil?
                if current_user.unidade_id < 42 or current_user.unidade_id > 53
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id < 26 or id > 27"])
                end

            else
                if current_user.unidade_id < 42 or current_user.unidade_id > 53
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id != 27 and id !=26"])
                end
            end
        else
            @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ?', current_user.unidade_id, Time.now.year], :order => 'classe_classe ASC')
            if current_user.professor_id.nil?
                if current_user.unidade_id < 42 or current_user.unidade_id > 53
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id < 26 or id > 27"])
                end

            else
                if current_user.unidade_id < 42 or current_user.unidade_id > 53
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id != 27 and id !=26"])
                end


            end


        end
    end

    def load_professors
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @professors = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
            #@professors1 = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
            @professor_unidade = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
            #@alunos1 = Aluno.find(:all, :select => 'id, aluno_nome', :joins => ['matricula', 'classe'], :conditions => 'classes.classe_classe == 1' , :order => 'aluno_nome ASC' )
            #@alunos3 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
            @alunos_boletim = @alunos1


        else
            #@professors1 = Professor.find(:all, :conditions => ['id = ? AND desligado = 0', current_user.professor_id  ],:order => 'nome ASC')
            @professors = Professor.find(:all, :conditions => 'desligado = 0', :order => 'nome ASC')
            @professor_unidade = Professor.find(:all, :conditions => ['(unidade_id = ? or unidade_id = 52 or unidade_id = 54) AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
            #@alunos1 = Aluno.find(:all, :select => 'id, aluno_nome',:joins => ['matricula', 'classe'], :conditions => ['alunos.unidade_id =? AND matriculas.ano_letivo = ? AND classes.classe_classe =! "EJA""',current_user.unidade_id, Time.now.year],:order => 'aluno_nome ASC' )
            #@alunos1 = Aluno.find(:all, :select => 'distinct(alunos.id), alunos.aluno_nome',:joins => "inner join matriculas on alunos.id = matriculas.aluno_id inner join classes on classes.id = matriculas.classe_id", :conditions => ['alunos.unidade_id =? AND matriculas.ano_letivo = ? AND classes.classe_classe != "EJA"',current_user.unidade_id, Time.now.year],:order => 'aluno_nome ASC' )
            @alunos1=Matricula.find(:all,:select=>"alunos.aluno_nome, alunos.id",:joins=> "left join alunos ON alunos.id=matriculas.aluno_id",:conditions=>["matriculas.unidade_id=? AND matriculas.ano_letivo=?",current_user.unidade_id,Time.now.year],:order => 'alunos.aluno_nome ASC')
            


            #@alunos3 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
            @alunos_boletim = @alunos1
        end
    end


    def load_disciplinas
      
        if current_user.professor_id.nil?
            if current_user.unidade_id < 42 or current_user.unidade_id > 53
                @disciplinas = Disciplina.find(:all, :conditions => ["curriculo = 'I'"])
                @nota=Nota.find(62)
            else
                @disciplinas = Disciplina.find(:all, :conditions => ["curriculo != 'I'"])
                @nota=Nota.find(62)
            end

        else
            if current_user.unidade_id < 42 or current_user.unidade_id > 53
                @disciplinas = Disciplina.find(:all, :conditions => ["curriculo = 'I'"])
                @nota=Nota.find(62)
            else
                @disciplinas = Disciplina.find(:all, :conditions =>  ["curriculo != 'I'"])
                @nota=Nota.find(62)
            end
        end

    end

    def load_iniciais
        @disciplinasB = Disciplina.find(:all, :conditions=>['curriculo = "B"'])
        @ano =   ObservacaoNota.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
        @ano_boletim =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo ASC')
        @alunos2 = Aluno.find(:all,:select => 'id, aluno_nome',  :conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
        #@alunos1 = Classe.find(:all,:select => 'alunos.id, alunos.aluno_nome',  :joins =>  [:matriculas, :alunos] , :conditions =>['alunos.unidade_id=? AND alunos.aluno_status is null AND  matriculas.aluno_id = alunos.id AND classes.classe.classe != "EJA" ' , current_user.unidade_id],:order => 'aluno_nome')
        #Não lembro porque coloquei ano letivo neste select @alunos_nome
        #portanto estou mantendo uma cópia a seguir e criando outra linha sem o ano_letivo logo em seguida também
        #@alunos_nome = Aluno.find(:all,:select => 'distinct(alunos.id), aluno_nome, aluno_nascimento',:joins => "INNER JOIN matriculas ON alunos.id=matriculas.aluno_id INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.unidade_id=? AND classes.classe_classe!="EJA" AND classes.classe_ano_letivo=?', current_user.unidade_id, Time.now.year], :order => 'aluno_nome ASC')
        @alunos_nome = Aluno.find(:all,:select => 'distinct(alunos.id), aluno_nome, aluno_nascimento',:joins => "INNER JOIN matriculas ON alunos.id=matriculas.aluno_id INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.unidade_id=? AND classes.classe_classe!="EJA" AND matriculas.ano_letivo<?', current_user.unidade_id, Time.now.year], :order => 'aluno_nome ASC')
        @alunos1 = Aluno.find(:all, :joins => "INNER JOIN matriculas ON alunos.id=matriculas.aluno_id INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.unidade_id=? AND classes.classe_classe!="EJA" AND classes.classe_ano_letivo=?', current_user.unidade_id, Time.now.year], :order => 'aluno_nome ASC')
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @classe = Classe.find(:all, :order => 'classe_classe ASC')
        else
            @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
            @classes = Classe.find(:all, :conditions => ['unidade_id = ?', current_user.unidade_id ], :order => 'classe_ano_letivo ASC, classe_classe ASC')

        end

    end

end
