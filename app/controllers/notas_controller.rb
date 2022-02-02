class NotasController < ApplicationController
    before_filter :load_classes

    def update_multiplas_notas
        Nota.update(params[:nota].keys, params[:nota].values)
        flash[:notice] = 'NOTAS LANÇADAS.'
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id],Time.now.year])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
        @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",   session[:classe_id] , session[:professor_id], session[:disc_id],Time.now.year ],:readonly => false,:order => 'matriculas.classe_num ASC')
        for nota_somaf in @notas
            soma=0
            if !nota_somaf.faltas1.nil?
                soma=soma+nota_somaf.faltas1.to_i
            end
            if !nota_somaf.faltas2.nil?
                soma=soma+nota_somaf.faltas2.to_i
            end
            if !nota_somaf.faltas3.nil?
                soma=soma+nota_somaf.faltas3.to_i
            end
            if !nota_somaf.faltas4.nil?
                soma=soma+nota_somaf.faltas4.to_i
            end
            nota_somaf.faltas5 = soma
            nota_somaf.save
        end
        render 'notas_lancamentos_multiplos'
    end

    def index
        @notas = Nota.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @notas }
        end
    end

    def show
        @nota = Nota.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @nota }
        end
    end

    def new



        cont=1
        @ano_letivo=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        @serie=[1,2,3,4,5,6,7,8,9]
        for i in 0..14
            @ano_letivo[i]=Time.now.year.to_i-(15-i)
        end
=begin
        while (cont < session[:classe_nota]) do
            @ano_letivo[cont-1] = (session[:ano] - cont).to_s
            @serie[cont-1] = (session[:classe_nota]-cont).to_s
            cont=cont+1
        end
=end
        @nota = Nota.new
        session[:flagx]=0
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @nota }
        end
    end

    def new1
        @nota = Nota.new
        session[:flagx]=1
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @nota }
        end
    end

    def edit
        @atribuicao = Atribuicao.find(:all,:conditions =>['classe_id=? and professor_id=? and disciplina_id=?', session[:classe_id], session[:professor_id], session[:disc_id]])
        @nota = Nota.find(params[:id])
        session[:id_nota] = params[:id]
        session[:new2_aluno_id]= @nota.aluno_id
        session[:edit]=0
    end

   def edit_lancamento_aulas_compensadas
        @atribuicao = Atribuicao.find(:all,:conditions =>['classe_id=? and professor_id=? and disciplina_id=?', session[:classe_id], session[:professor_id], session[:disc_id]])
        @nota = Nota.find(params[:id])
        session[:id_nota] = params[:id]
        session[:new2_aluno_id]= @nota.aluno_id
        session[:edit]=1
    end

   def lancamento_aulas_compensadas
           if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            session[:professor_id]= params[:professor][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            for atrib in @atribuicao_classe
                session[:atrib_id] = atrib.id
            end
            session[:classe_id]
            session[:disc_id]
            session[:atrib_id]
            @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo = ?",  params[:classe][:id], params[:professor][:id], session[:disc_id], Time.now.year],:order => 'matriculas.classe_num ASC')
        end
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @classes }
        end

   end






    def observacao
        @atribuicao = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', session[:classe_id], session[:professor_id], session[:disc_id]])
        @nota = Nota.find(params[:id])
        session[:id_nota] = params[:id]
        session[:new2_aluno_id]= @nota.aluno_id
        
    end




    def aviso
    
    end

    def botao
        params[:nota_ano_letivo]
        
        render :partial => 'ok'
    end
  
    def create


        @nota = Nota.new(params[:nota])
        if session[:flagx]!=1
            if  @nota.classe>0
                @cl_ano=ObservacaoHistorico.find(:all, :select => 'id, classe, ano_letivo, CONCAT(classe,"º série (",ano_letivo,")") as cl_ano', :conditions => ["id=?", @nota.classe])
                @nota.classe=@cl_ano[0].classe
                @nota.ano_letivo=@cl_ano[0].ano_letivo
            end
        end
        if  session[:cont_nome]=1
            @nota.aluno_id=session[:aluno_id]
        end
        @existe=Nota.find(:all, :select => 'id,aluno_id', :conditions => ['aluno_id =? and disciplina_id=? and ano_letivo=? and ativo<>1', @nota.aluno_id, @nota.disciplina_id, @nota.ano_letivo])
#        @nota.aluno_id
#        @nota.disciplina_id
#        @nota.ano_letivo

        if !@existe.empty?
            respond_to do |format|
                session[:aluno]= @nota.aluno.aluno_nome
                session[:ano_letivo]= @nota.ano_letivo
                session[:disciplina]= @nota.disciplina.disciplina
                session[:nota]= @nota.nota5
                session[:faltas]= @nota.faltas5
                format.html {redirect_to(historico_aviso_path) }
            end
        else
            session[:disciplina] = @nota.disciplina.disciplina
            @nota.unidade_id =  current_user.unidade_id
            if session[:flagx] == 1
                @nota.classe = session[:classe]
  #              @nota.escola = session[:escola]
                @nota.ano_letivo = session[:ano_letivo]
  #              @nota.escola = session[:escola]
            end
#            if @nota.escola =='    Favor digitar o Nome da Escola - Cidade - Estado'
 #               @nota.escola = ' '
#            end

            w1= session[:classe]
            session[:disc]= @nota.disciplina.disciplina
            session[:alu]= @nota.aluno.aluno_nome
            session[:ano] =@nota.ano_letivo
            session[:clas] = @nota.classe
            session[:nota] = @nota.nota5
             
            @existe_lancamento=Nota.find(:all, :select => 'id,aluno_id', :conditions => ['aluno_id =? and disciplina_id=? and ano_letivo=? and classe =? ', @nota.aluno_id, @nota.disciplina_id, @nota.ano_letivo, @nota.classe])
t=0
            if !@existe_lancamento.present?

                    respond_to do |format|
                        if @nota.save
                            session[:cont_nome]=0
                            flash[:notice] = 'SALVO COM SUCESSO.'
                            session[:classe]= @nota.classe
                            session[:nota_id]= @nota.id
                            session[:aluno_id]=@nota.aluno_id
                            session[:disciplina_id]= @nota.disciplina_id
                            session[:ano_letivo]= @nota.ano_letivo
        #                    session[:escola]= @nota.escola
                            format.html { redirect_to(@nota) }
                            format.xml  { render :xml => @nota, :status => :created, :location => @nota }
                        else
                            format.html { render :action => "new" }
                            format.xml  { render :xml => @nota.errors, :status => :unprocessable_entity }
                        end
                    end

            else
                 respond_to do |format|
                #flash[:notice] = 'CADASTRADO COM SUCESSO.'
                format.html { redirect_to(aviso_atividades_path) }
                format.xml  { head :ok }
            end
            end
        end
    end
  


    def create_observacao_nota

        t=params[:observacao_nota]
        @observacao_nota = ObservacaoNota.new(params[:observacao_nota])
        t1=params[:observacao_nota]

        @nota = Nota.find(session[:id_nota])
        @observacao_nota.nota_id =@nota.id
        @observacao_nota.data = Time.now
        @observacao_nota.ano_letivo =  Time.now.year

        if @observacao_nota.save

            render :update do |page|
                page.replace_html 'dados', :partial => "observacoes"
                page.replace_html 'edit'
            end
        end

    end

  
  def update
    if session[:edit]==0
        @nota = Nota.find(params[:id])
        session[:classe_id]= @nota.atribuicao.classe_id
        session[:professor_id]=@nota.professor_id
        session[:disc_id]=@nota.atribuicao.disciplina_id
        if @nota.update_attributes(params[:nota])
            session[:id]
            session[:aluno]
            session[:nota_id] = @nota.id
            @disci = Disciplina.find(:all, :conditions => ["id =?",session[:disc_id]])
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?',  session[:classe_id],session[:professor_id], session[:disc_id]])
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?',  session[:classe_id], session[:professor_id], session[:disc_id]])

            for atrib in  @atribuicao_classe
                @nota.aulas1 = atrib.aulas1
                @nota.aulas2 = atrib.aulas2
                @nota.aulas3 = atrib.aulas3
                @nota.aulas4 = atrib.aulas4
            end
            if (@nota[:faltas1] == 0)
                @nota.freq1= 100
            else
                session[:aulas1]= @nota.aulas1.to_f
                session[:faltas1]= @nota.faltas1.to_f
                @nota.freq1= 100 -((session[:faltas1] / session[:aulas1])*100)
            end
            if (@nota[:faltas2] == 0)
                @nota.freq2= 100
            else
                session[:aulas2]= @nota.aulas2.to_f
                session[:faltas2]= @nota.faltas2.to_f
                @nota.freq2= 100 -((session[:faltas2] / session[:aulas2])*100)
            end
            if (@nota[:faltas3] == 0)
                @nota.freq3= 100
            else
                session[:aulas3]= @nota.aulas3.to_f
                session[:faltas3]= @nota.faltas3.to_f
                @nota.freq3= 100 -((session[:faltas3] / session[:aulas3])*100)
            end
            if (@nota[:faltas4] == 0)
                @nota.freq4= 100
            else
                session[:aulas4]= @nota.aulas4.to_f
                session[:faltas4]= @nota.faltas4.to_f
                @nota.freq4= 100 -((session[:faltas4] / session[:aulas4])*100)
            end
            @nota.aulas5 = @nota.aulas1 + @nota.aulas2 + @nota.aulas3 + @nota.aulas4
            soma=0
            if !@nota.faltas1.nil?
                soma=soma+@nota.faltas1.to_i
            end
            if !@nota.faltas2.nil?
                soma=soma+@nota.faltas2.to_i
            end
            if !@nota.faltas3.nil?
                soma=soma+@nota.faltas3.to_i
            end
            if !@nota.faltas4.nil?
                soma=soma+@nota.faltas4.to_i
            end
w0=soma
w1=@nota.faltas1
w2=@nota.faltas2
w3=@nota.faltas3
w4=@nota.faltas4
w5=@nota.faltas5
            @nota.faltas5 = soma
            if (@nota[:faltas5] == 0)
                @nota.freq5= 100
            else
                session[:aulas5]= (@nota.aulas5.to_f)
                session[:faltas5]= (@nota.faltas5.to_f)
                @nota.freq5= 100 - ((session[:faltas5] / session[:aulas5])*100)
            end

            if @nota.nota1 == '---'
                @nota.nota1= nil
            end
            if @nota.nota2 == '---'
                @nota.nota2= nil
            end
            if @nota.nota3 == '---'
                @nota.nota3= nil
            end
            if @nota.nota4 == '---'
                @nota.nota4= nil
            end
            @atribuicao_classe[0].disciplina_id

            @nota.save
        end

        @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",session[:classe_id], session[:professor_id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
        if current_user.has_role?('professor_fundamental')
#           @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",session[:classe_id], session[:professor_id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
            render 'notas_lancamentos'
        else
#           @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",session[:classe_id], session[:professor_id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
            render lancamentos_notas_notas_path , :layout => "layouts/application"
        end
     end
     if session[:edit]==1

        @nota = Nota.find(params[:id])
        session[:classe_id]= @nota.atribuicao.classe_id
        session[:professor_id]=@nota.professor_id
        session[:disc_id]=@nota.atribuicao.disciplina_id
        if @nota.update_attributes(params[:nota])
           @nota.comp5 = @nota.comp1+@nota.comp2+@nota.comp3+@nota.comp4
           @nota.save
           @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?',  session[:classe_id],session[:professor_id], session[:disc_id]])
           @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?',  session[:classe_id], session[:professor_id], session[:disc_id]])
           @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",session[:classe_id], session[:professor_id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
           render lancamento_aulas_compensadas_notas_path , :layout => "layouts/application"

        end
     end

  end


    def atribuicao_lancamentos_notas
        render :partial => 'notas_lancamentos', :layout => "layouts/application"
    end

    def destroy
        @nota = Nota.find(params[:id])
        @nota.destroy
        respond_to do |format|
            format.html { redirect_to(home_url) }
            format.xml  { head :ok }
        end
    end

    def consulta_nota_aluno
        @classe = Classe.find(:all,:conditions =>['id = ? and professor_id =?', params[:classe][:id], current_user.id])
        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_classe'
        end
    end

    def voltar_lancamento_notas
        t=0
        @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
        for dis in @disci
            session[:disc_id] = dis.id
        end
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', session[:classe_id], session[:professor_id], session[:disc_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', session[:classe_id], session[:professor_id], session[:disc_id]])
        for atrib in @atribuicao_classe
            session[:atrib_id] = atrib.id
        end
        @notas1 = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=? and notas.ativo is null" , session[:classe_id], session[:professor_id], session[:disc_id], Time.now.year ],:order => 'alunos.aluno_nome ASC')
        @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=? and notas.ativo is null",session[:classe_id], session[:professor_id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
        teste = current_user.id
        t=0
        if current_user.has_role?('professor_fundamental') or (teste == 1452 or teste == 2)     # excessão para usuário 1452 PEGAGOG fazer multiplos lançamentos
            #render :partial => 'notas_lancamentos', :layout => "layouts/aalunos"
            session[:conta]=0
            render "notas_lancamentos_multiplos", :layout => "layouts/application"
        else

            render "notas_lancamentos", :layout => "layouts/application"
            #render :partial => 'notas_lancamentos', :layout => "layouts/aalunos"
        end
    end


    def consulta_classe_nota
        t=params[:classe][:id]
        t1= params[:professor][:id]

        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ?', params[:classe][:id], params[:professor][:id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =?', params[:classe][:id], params[:professor][:id]])
        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_classe'
        end
    end

    def create_notas_aluno
        t=params[:notas_aluno]
        @notas_aluno = Nota.new(params[:notas_aluno])
        if @notas_aluno.save
            render :update do |page|
                #page.replace_html 'dados', :partial => "observacoes"
                page.replace_html 'edit'
            end
        end

    end


    def relatorio_classe
        if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            session[:professor_id]= params[:professor][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            #@transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
            #@notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]])
            #@alunos1 = Aluno.find(:all, :joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]])
        end
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @classes }
        end
    end


    def lancamentos_notas
        t=0
        if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            session[:professor_id]= params[:professor][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            for atrib in @atribuicao_classe
                session[:atrib_id] = atrib.id
            end
            session[:classe_id]
            session[:disc_id]
            session[:atrib_id]
            @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo = ? AND notas.ativo is NULL",  params[:classe][:id], params[:professor][:id], session[:disc_id], Time.now.year],:order => 'matriculas.classe_num ASC')
        end
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @classes }
        end
    end



    def lancamentos_observacaos
        t=0
        if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            session[:professor_id]= params[:professor][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            for atrib in @atribuicao_classe
                session[:atrib_id] = atrib.id
            end
            session[:classe_id]
            session[:disc_id]
            session[:atrib_id]
            @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo = ?",  params[:classe][:id], params[:professor][:id], session[:disc_id], Time.now.year],:order => 'matriculas.classe_num ASC')
        end
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @classes }
        end
    end


    def impressao_alteracao_lancamentos
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?',session[:classe_id], session[:professor_id], session[:disc_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?',session[:classe_id], session[:professor_id], session[:disc_id]])
        @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
        @notas = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?", session[:classe_id], session[:professor_id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
        render :layout => "impressao"

    end

    def impressao_lancamentos_notas
 
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?',session[:classe_id], session[:professor_id], session[:disc_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?',session[:classe_id], session[:professor_id], session[:disc_id]])
        @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
        @notas = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?", session[:classe_id], session[:professor_id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
 
        render :layout => "impressao"

    end


    def lancar_notas

    end


    def lancar_notas_alunos
     if params[:type_of].to_i == 1
             if ( params[:disciplina].present?)
                  params[:disciplina]
                  @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
                  for dis in @disci
                      session[:disc_id] = dis.id
                      session[:disc] = dis.nucleo_comum
                  end
                  session[:classe_id] = params[:classe][:id]
                  session[:professor_id]= params[:professor][:id]
                  session[:current_user_unidade_id]= current_user.unidade_id
                  @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =? AND ano_letivo=?', params[:classe][:id], params[:professor][:id], session[:disc_id],Time.now.year])
                  @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', params[:classe][:id], params[:professor][:id], session[:disc_id], Time.now.year])
                  for atrib in @atribuicao_classe
                      session[:atrib_id] = atrib.id
                  end
                  @notas1 = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?" ,  params[:classe][:id], params[:professor][:id], session[:disc_id], Time.now.year ],:order => 'alunos.aluno_nome ASC')
                  @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",  params[:classe][:id], params[:professor][:id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
                  for classe in @classe
                      session[:num_classe]= classe.classe_classe[0,1].to_i
                  end
                 ww1=session[:dataI]= BIM1INI  #params[:aulas][:inicioIA][6,4]+'-'+params[:aulas][:inicioIA][3,2]+'-'+params[:aulas][:inicioIA][0,2]
                 ww2=session[:dataF]= BIM1FIM #params[:aulas][:fimIA][6,4]+'-'+params[:aulas][:fimIA][3,2]+'-'+params[:aulas][:fimIA][0,2]
                 ww3=session[:dataII]=BIM1INIP #params[:aulas][:inicioIA][0,2]+'/'+params[:aulas][:inicioIA][3,2]+'/'+params[:aulas][:inicioIA][6,4]
                 ww4=session[:dataFF]= BIM1FIMP #params[:aulas][:fimIA][0,2]+'/'+params[:aulas][:fimIA][3,2]+'/'+params[:aulas][:fimIA][6,4]

               if  current_user.has_role?('professor_fundamental')
               w1 = session[:cont_classe_id]
               w2= session[:disciplina_id]
               w3=  session[:professor_id]
               @faltasalunos = Faltasaluno.find(:all, :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id=? AND professor_id=?" ,   session[:dataI], session[:dataF], session[:classe_id], session[:disc_id],  session[:professor_id]] , :order => 'data DESC, classe_id ASC')
               @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND disciplina_id=? AND professor_id=?" ,   session[:dataI], session[:dataF], session[:classe_id], session[:disc_id],  session[:professor_id]] , :order => 'data DESC, classe_id ASC')
               session[:total_aulas]= @faltasalunosdias.count
      t=0
              # @faltasalunosdias = Faltasaluno.find(:all, :select=> 'distinct(data)', :joins =>:classe, :conditions =>  ["data >=? AND  data <=? AND classe_id = ? AND professor_id=?",   session[:dataI], session[:dataF], session[:cont_classe_id], current_user.professor_id] , :order => 'data DESC, classe_id ASC')
              #      if classeAEE == 'AEE'
              #       @alunos_matriculados = Aluno.find(:all, :joins =>[:atendimento_aee], :select => "atendimento_aees.classe_num , alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome,  atendimento_aees.status as situacao"  , :joins => "INNER JOIN atendimento_aees on alunos.id = atendimento_aees.aluno_id", :conditions => ["atendimento_aees.classe_id = ? AND atendimento_aees.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO')", session[:cont_classe_id], Time.now.year  ] )
              #         session[:AEE]=1
              #      else
              #         @alunos_matriculados = Aluno.find(:all, :select => "alunos.id , matriculas.classe_num , alunos.aluno_nome	 ,CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero, matriculas.status as situacao"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') ", session[:cont_classe_id], Time.now.year  ],:order => 'classe_num ASC' )
              #         session[:AEE]=0
              #      end
              #       t=0
              end



                  if @notas[0].nil?
                      render :update do |page|
                          page.replace_html 'notas', :partial => 'aviso'
                      end
                  else
                      session[:aluno_id]= @notas[0].aluno_id
                      render :update do |page|
                          page.replace_html 'notas', :partial => 'aulas'
                      end
                  end
           end
        end    #end  1º bim




    end


    def classe_professor
      w1= params[:professor_id]
       @professor = Professor.find(:all, :conditions => ['id=?', params[:professor_id]])
       unidade= @professor[0].unidade_id
       @unidade = Unidade.find(:all, :conditions => ['id=?', unidade])
       w = session[:unidade]= @unidade[0].nome

    end


    def load_classes
        @NOTASH = ["SN","10.0","9.5","9.0","8.5","8.0","7.5","7.0","6.5","6.0","5.5","5.0","4.5","4.0","3.5","3.0","2.5","2.0","1.5","1.0","0.5","0.0","A","B","C","D","E","TR","RM","F","NF","ABN","I","P","S","DS","DP","DI"]
        @NOTASB1 = [nil,"SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB2 = [nil,"SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB3 = [nil,"SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB4 = [nil,"SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB5 = [nil,"SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('direcao_fundamental')or current_user.has_role?('pedagogo'))
            if (current_user.unidade_id == 53 or current_user.unidade_id == 52)

                #@classes = Classe.find(:all, :order => 'classe_classe ASC')
                @classes = Classe.find(:all, :select => 'classes.id, classe_classe as classe, classe_ano_letivo, CONCAT(classe_classe," - ",unidades.nome) as classe_classe', :joins => :unidade, :conditions=>['classe_ano_letivo=?', Time.now.year], :order => 'classe_classe ASC')
                  #@serie=ObservacaoHistorico.find(:all, :select => 'id, classe, ano_letivo, CONCAT(classe,"º série (",ano_letivo,")") as cl_ano', :conditions => ["aluno_id=? AND classe IS NOT NULL", session[:aluno_id]], :order => 'classe')
            else
                @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
            end
            #@classes = Classe.find.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM dis-ciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id =1326 AND atribuicaos.ano_letivo = "+Time.now.year.to_s)..uniq
            #@disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id =1326 AND atribuicaos.ano_letivo = "+Time.now.year.to_s)
            @disciplinas1 = Disciplina.find(:all,:conditions => ['nao_disciplina = 0'],:order => 'ordem ASC' )
            @disciplinas = Disciplina.find(:all,:conditions => ['nao_disciplina = 0'],:order => 'ordem ASC' )
            #@disciplinas2 = Disciplina.find(:all, :conditions =>'curriculo != "I"  ', :order => 'ordem ASC' )
            if (current_user.unidade_id == 53 or current_user.unidade_id == 52)
                @professors1 = Professor.find(:all, :conditions => ['desligado = 0 AND diversas_unidades=1'],   :order => 'nome ASC')
            else
                @professors1 = Professor.find(:all, :conditions => ['desligado = 0 AND (diversas_unidades =1 OR unidade_id =?)',current_user.unidade_id],   :order => 'nome ASC')

            end

            if (current_user.unidade_id == 53 or current_user.unidade_id == 52)
                @alunos = Aluno.find(:all,:order => 'aluno_nome ASC')
            else
                @alunos = Aluno.find(:all, :conditions => ['unidade_id=? AND aluno_status is null', current_user.unidade_id],   :order => 'aluno_nome ASC')
            end
        else

            if current_user.has_role?('professor_fundamental')
                @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
                @disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id = "+(current_user.professor_id).to_s + " AND atribuicaos.ano_letivo = "+Time.now.year.to_s)
                @professors1 = Professor.find(:all, :conditions => [' id = ? AND desligado = 0', current_user.professor_id  ],:order => 'nome ASC')
                @alunos = Aluno.find(:all, :conditions => ['unidade_id=? AND aluno_status is null', current_user.unidade_id],   :order => 'aluno_nome ASC')
                @disciplinas = Disciplina.find(:all,:order => 'ordem ASC' )
                #@disciplinas2 = Disciplina.find(:all, :conditions =>'curriculo != "I" ', :order => 'ordem ASC' )
            else if current_user.has_role?('secretaria_fundamental')
                    @alunos = Aluno.find(:all, :conditions => ['unidade_id=? AND aluno_status is null', current_user.unidade_id],   :order => 'aluno_nome ASC')
                    @disciplinas = Disciplina.find(:all,:order => 'ordem ASC' )
                    @professors1 = Professor.find(:all, :conditions => ['desligado = 0'],   :order => 'nome ASC')

                    #@disciplinas2 = Disciplina.find(:all, :conditions =>'curriculo != "I" ', :order => 'ordem ASC' )
                end
            end

        end
    end
end
