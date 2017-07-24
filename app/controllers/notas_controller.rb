class NotasController < ApplicationController
before_filter :load_classes

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
    @atribuicao = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', session[:classe_id], session[:professor_id], session[:disc_id]])
    @nota = Nota.find(params[:id])
    session[:id_nota] = params[:id]
    
  end

  def aviso
    
  end

  
 def create

    @nota = Nota.new(params[:nota])
    @existe= Nota.find(:all, :select => 'id,aluno_id', :conditions => ['aluno_id =? and disciplina_id=? and ano_letivo=?', @nota.aluno_id, @nota.disciplina_id, @nota.ano_letivo])
t=0
    if !@existe.empty?
       respond_to do |format|
         
         session[:aluno]= @nota.aluno.aluno_nome
         session[:ano]= @nota.ano_letivo
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
           @nota.escola = session[:escola]
           @nota.ano_letivo = session[:ano_letivo]
           @nota.escola = session[:escola]

        end
        if @nota.escola =='    Favor digitar o Nome da Escola - Cidade - Estado'
           @nota.escola = ' '
        end
       respond_to do |format|
          if @nota.save
            flash[:notice] = 'SALVO COM SUCESSO.'
            session[:classe]= @nota.classe
            session[:nota_id]= @nota.id
            session[:aluno_id]=@nota.aluno_id
            session[:disciplina_id]= @nota.disciplina_id
            session[:ano_letivo]= @nota.ano_letivo
            session[:escola]= @nota.escola
            format.html { redirect_to(@nota) }
            format.xml  { render :xml => @nota, :status => :created, :location => @nota }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @nota.errors, :status => :unprocessable_entity }
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
     @nota = Nota.find(params[:id])
     session[:classe_id]= @nota.atribuicao.classe_id
     session[:professor_id]=@nota.professor_id
     session[:disc_id]=@nota.atribuicao.disciplina_id
    

     if @nota.update_attributes(params[:nota])
        session[:id]
        session[:aluno]
        #@nota = Nota.all(:conditions => ["atribuicao_id =? AND aluno_id =? AND ano_letivo =? ", session[:id], session[:aluno], Time.now.year])
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
        @nota.faltas5 = @nota.faltas1 + @nota.faltas2 + @nota.faltas3 + @nota.faltas4
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
     w=@atribuicao_classe[0].disciplina_id

# outras atribuições do mesmo professor (nucleo comum)
#
#
#    if @atribuicao_classe[0].disciplina_id == 1
#       @outras_atribuicaos = Atribuicao.find(:all,:conditions =>["classe_id = ? and professor_id = ? and ano_letivo    = ?  and (disciplina_id = 32 OR disciplina_id = 2 OR disciplina_id = 3 OR disciplina_id = 4 OR disciplina_id = 21 OR disciplina_id=34)", session[:classe_id],    session[:professor_id], Time.now.year])
#        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id = ? and disciplina_id = ?',session[:classe_id],     session[:professor_id], session[:disc_id]])
#
#
#        for atrib in  @outras_atribuicaos
#          @notas = Nota.find(:all, :conditions => ["aluno_id=? AND atribuicao_id =? AND professor_id=? AND disciplina_id=? AND notas.ano_letivo=?", session[:aluno_nota], atrib.id, atrib.professor_id, atrib.disciplina_id,  Time.now.year])
#           for nota in @notas
#             nota.faltas1 = @nota.faltas1
#             nota.faltas2 = @nota.faltas2
#             nota.faltas3 = @nota.faltas3
#             nota.faltas4 = @nota.faltas4
#
#            if (@nota.faltas1 == 0)
#               nota.freq1= 100
#            else
#               session[:aulas1]= @nota.aulas1.to_f
#               session[:faltas1]= @nota.faltas1.to_f
#               nota.freq1= 100 -((session[:faltas1] / session[:aulas1])*100)
#            end
#            if (@nota.faltas2 == 0)
#               nota.freq2= 100
#            else
#               session[:aulas2]= @nota.aulas2.to_f
#               session[:faltas2]= @nota.faltas2.to_f
#               nota.freq2= 100 -((session[:faltas2] / session[:aulas2])*100)
#
#             end
#            if (@nota.faltas3 == 0)
#               nota.freq3= 100
#            else
#               session[:aulas3]= @nota.aulas3.to_f
#               session[:faltas3]= @nota.faltas3.to_f
#               nota.freq3= 100 -((session[:faltas3] / session[:aulas3])*100)
#             end
#            if (@nota.faltas4 == 0)
#               nota.freq4= 100
#            else
#               session[:aulas4]= @nota.aulas4.to_f
#               session[:faltas4]= @nota.faltas4.to_f
#               nota.freq4= 100 -((session[:faltas4] / session[:aulas4])*100)
#             end
#             nota.aulas5 = nota.aulas1 + nota.aulas2 + nota.aulas3 + nota.aulas4
#             nota.faltas5 = @nota.faltas1 + @nota.faltas2 + @nota.faltas3 + @nota.faltas4
#            if (nota.faltas5 == 0)
#              nota.freq5= 100
#            else
#               session[:aulas5] = (@nota.aulas5.to_f)
#               session[:faltas5] = (@nota.faltas5.to_f)
#               nota.freq5=100 - ((session[:faltas5] / session[:aulas5])*100)
#             end
#           nota.save
#
#        end
#
#      end
#    end

      @nota.save
   end
    if current_user.has_role?('professor_fundamental')
        @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",session[:classe_id], session[:professor_id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
        render 'notas_lancamentos'
    else
        @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",session[:classe_id], session[:professor_id], session[:disc_id],Time.now.year ],:order => 'matriculas.classe_num ASC')
        render lancamentos_notas_notas_path , :layout => "layouts/application"
    end

  end

def atribuicao_lancamentos_notas
    render :partial => 'notas_lancamentos', :layout => "layouts/aalunos"
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
         if current_user.has_role?('professor_fundamental')

               #render :partial => 'notas_lancamentos', :layout => "layouts/aalunos"
               render "notas_lancamentos", :layout => "layouts/application"
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
 end


  def load_classes
        @NOTASB1 = ["SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB2 = ["SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB3 = ["SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB4 = ["SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
        @NOTASB5 = ["SN","10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0","TR","RM","F","NF","ABN"]
   if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('direcao_fundamental')or current_user.has_role?('pedagogo'))
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52)
           @classes = Classe.find(:all, :order => 'classe_classe ASC')
         else
            @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
         end
        #@classes = Classe.find.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM dis-ciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id =1326 AND atribuicaos.ano_letivo = "+Time.now.year.to_s)..uniq
        #@disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id =1326 AND atribuicaos.ano_letivo = "+Time.now.year.to_s)
        @disciplinas1 = Disciplina.all(:order => 'ordem ASC' )
        @disciplinas = Disciplina.find(:all,:order => 'ordem ASC' )
        @disciplinas2 = Disciplina.find(:all, :conditions =>'curriculo != "I" ', :order => 'ordem ASC' )
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
            @disciplinas2 = Disciplina.find(:all, :conditions =>'curriculo != "I" ', :order => 'ordem ASC' )
       else if current_user.has_role?('secretaria_fundamental')
                @alunos = Aluno.find(:all, :conditions => ['unidade_id=? AND aluno_status is null', current_user.unidade_id],   :order => 'aluno_nome ASC')
                @disciplinas = Disciplina.find(:all,:order => 'ordem ASC' )
                @professors1 = Professor.find(:all, :conditions => ['desligado = 0'],   :order => 'nome ASC')

                @disciplinas2 = Disciplina.find(:all, :conditions =>'curriculo != "I" ', :order => 'ordem ASC' )
           end
       end

    end
 end



end
