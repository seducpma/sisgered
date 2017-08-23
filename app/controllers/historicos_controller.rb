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
            @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
            @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
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
            render :update do |page|
                page.replace_html 'dados_historico', :partial => "notas_historico"
            end
        end

    end

    def create_observacao_historico

        @observacao_historico = ObservacaoHistorico.new(params[:observacao_historico])
        @observacao_historico.aluno_id = session[:aluno_id]
        @observacao_historico.ano_letivo = Time.now.year
        @observacao_historico.data = Time.now
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
            @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", session[:aluno_imp], current_user.unidade_id, session[:ano_imp]],:order =>'disciplinas.ordem ASC ')
            @notas = @notasB+@notasD

            respond_to do |format|
                format.html # index.html.erb
                format.xml  { render :xml => @notas }
            end
        end
    end


    def historico
        if  (params[:aluno_id].present?)
            session[:aluno_id] = params[:aluno_id]
            @aluno = Aluno.find(:all, :select => 'id, aluno_nome, unidade_id, aluno_ra, aluno_nascimento, aluno_certidao_nascimento, aluno_livro, aluno_folha, aluno_naturalidade, aluno_nacionalidade, aluno_chegada_brasil, aluno_RNE, aluno_validade_estrangeiro, aluno_RG, 	aluno_emissaoRG, 	aluno_CPF, 	aluno_emissaoCPF, photo_file_name,	photo_content_type,	photo_file_size',:conditions => ['id =?', params[:aluno_id]])
            for aluno in @aluno
                session[:unidade_id]= aluno.unidade_id
                session[:aluno_id]= aluno.id
                session[:aluno_nome] = aluno.aluno_nome
            end
            @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
            @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
            @disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
            @disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
            @notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' or notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
           #
            @notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO') ORDER BY notas.disciplina_id, notas.ano_letivo")
            

            session[:contnotaBTot]=(@notasB.count)
            session[:contnotaDTot]=(@notasD.count)
            @disciplinas = @disciplinasD + @disciplinasB
            #@notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
            @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
            @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
            
            
            @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
            
            @ano_final = Nota.find(:last, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
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
            #@notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO') ORDER BY notas.disciplina_id, notas.ano_letivo")
            @notasB = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id  WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B'  ORDER BY notas.disciplina_id, notas.ano_letivo")
            #@notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO') ORDER BY notas.disciplina_id, notas.ano_letivo")
            @notasD = Nota.find_by_sql("SELECT notas.id, di.disciplina, notas.escola, notas.cidade, notas.disciplina_id, notas.ano_letivo, notas.nota5, notas.matricula_id FROM `notas` JOIN disciplinas di ON di.id = notas.disciplina_id  WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D'  ORDER BY notas.disciplina_id, notas.ano_letivo")
            session[:contnotaBTot]=(@notasB.count)
            session[:contnotaDTot]=(@notasD.count)

            @disciplinas = @disciplinasD + @disciplinasB
            #@notasD= Nota.find(:all, :joins => [:disciplina], :conditions=> ['aluno_id=? AND disciplinas.curriculo=?', session[:aluno_id], "D"], :order => 'ano_letivo ASC')
            @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
            @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
            @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
             @ano_inicial.ano_letivo


            @ano_final = Nota.find(:last, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
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
            @ano_final = Nota.find(:last, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
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
            @alunos1 = Aluno.find(:all, :select => 'id, aluno_nome', :joins => ['matricula', 'classe'], :conditions => 'classes.classe_classe == 1' , :order => 'aluno_nome ASC' )
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
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @classe = Classe.find(:all, :order => 'classe_classe ASC')
        else
            @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
            @classes = Classe.find(:all, :conditions => ['unidade_id = ?', current_user.unidade_id ], :order => 'classe_ano_letivo ASC, classe_classe ASC')

        end

    end

end
