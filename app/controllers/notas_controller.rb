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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  def edit
    @nota = Nota.find(params[:id])
    session[:id_nota] = params[:id]
  end

  
 def create
    @nota = Nota.new(params[:nota])
    @nota.unidade_id =  current_user.unidade_id
   respond_to do |format|
      if @nota.save
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@nota) }
        format.xml  { render :xml => @nota, :status => :created, :location => @nota }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nota.errors, :status => :unprocessable_entity }
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

      if @observacao_nota.save

        render :update do |page|
          page.replace_html 'dados', :partial => "observacoes"
          page.replace_html 'edit'
        end
       end

end

  
  def update
    @nota = Nota.find(params[:id])
     if @nota.update_attributes(params[:nota])
        @nota = Nota.all(:conditions => ["atribuicao_id =? AND aluno_id =?", session[:id], session[:aluno_id]])

        session[:nota_id] = @nota.id
        @disci = Disciplina.find(:all, :conditions => ["id =?",session[:disc_id]])
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?',  session[:classe_id],session[:professor_id], session[:disc_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?',  session[:classe_id], session[:professor_id], session[:disc_id]])
        @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )

        @notast = Nota.find_by_sql("SELECT nt.* FROM transferencias tr JOIN notas nt ON tr.aluno_id = nt.aluno_id JOIN atribuicaos at ON tr.classe_id = at.classe_id WHERE (tr.unidade_id =" + (current_user.unidade_id).to_s + " AND tr.classe_id="+ (session[:classe_id]).to_s + " AND at.disciplina_id=" +(session[:disc_id]).to_s+" AND nt.atribuicao_id=" +(session[:atrib_id]).to_s+")")
        #@notas1 = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
        @notas1 = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=?",  session[:classe_id],session[:professor_id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
        @notas = @notas1- @notast
        render  :partial => 'notas'
                         
     end

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
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]])
       @alunos1 = Aluno.find(:all, :joins => "INNER JOIN  alunos_classes  ON  alunos.id=alunos_classes.aluno_id  INNER JOIN classes ON classes.id=alunos_classes.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]])
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
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       for atrib in @atribuicao_classe
            session[:atrib_id] = atrib.id
       end
         session[:classe_id]
         session[:disc_id]
         session[:atrib_id]
        @notast = Nota.find_by_sql("SELECT nt.* FROM transferencias tr JOIN notas nt ON tr.aluno_id = nt.aluno_id JOIN atribuicaos at ON tr.classe_id = at.classe_id WHERE (tr.unidade_id =" + (current_user.unidade_id).to_s + " AND tr.classe_id="+ (session[:classe_id]).to_s + " AND at.disciplina_id=" +(session[:disc_id]).to_s+" AND nt.atribuicao_id=" +(session[:atrib_id]).to_s+" AND nt.ativo is NULL" +")")
        @notas1 = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
        @notas = @notas1- @notast
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
      @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
        for dis in @disci
            session[:disc_id] = dis.id
        end
       session[:classe_id] = params[:classe][:id]
       session[:professor_id]= params[:professor][:id]
       session[:current_user_unidade_id]= current_user.unidade_id
       @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
       @transferencia = Transferencia.find(:all,  :conditions => ['unidade_id =? AND classe_id=?',current_user.unidade_id,  params[:classe][:id]] )

       for atrib in @atribuicao_classe
            session[:atrib_id] = atrib.id
       end

      @notast = Nota.find_by_sql("SELECT nt.* FROM transferencias tr JOIN notas nt ON tr.aluno_id = nt.aluno_id JOIN atribuicaos at ON tr.classe_id = at.classe_id WHERE (tr.unidade_id =" + (current_user.unidade_id).to_s + " AND tr.classe_id="+ (session[:classe_id]).to_s + " AND at.disciplina_id=" +(session[:disc_id]).to_s+" AND nt.atribuicao_id=" +(session[:atrib_id]).to_s+" AND nt.ativo is NULL" +")")
       @notas1 = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
      @notas = @notas1- @notast
       render :update do |page|
          page.replace_html 'notas', :partial => 'notas'
       end

  end
 end


 def load_classes

   if current_user.unidade_id == 53 or current_user.unidade_id == 52 or  current_user.has_role?('direcao') or  current_user.has_role?('pedagogo')
     t=0
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52)
           @classes = Classe.find(:all, :order => 'classe_classe ASC')
         else
            @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
         end
        @disciplinas1 = Disciplina.all(:order => 'ordem ASC' )
        @disciplinas = Disciplina.find(:all,:order => 'ordem ASC' )
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
       if current_user.has_role?('professor')
            @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
            @disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id = "+(current_user.professor_id).to_s + " AND atribuicaos.ano_letivo = "+Time.now.year.to_s)
            @professors1 = Professor.find(:all, :conditions => [' id = ? AND desligado = 0', current_user.professor_id  ],:order => 'nome ASC')
            @alunos = Aluno.find(:all, :conditions => ['unidade_id=? AND aluno_status is null ', current_user.unidade_id],   :order => 'aluno_nome ASC')

            @disciplinas = Disciplina.find(:all,:order => 'ordem ASC' )
       else if current_user.has_role?('secretaria')
                @alunos = Aluno.find(:all, :conditions => ['unidade_id=? AND aluno_status is null', current_user.unidade_id],   :order => 'aluno_nome ASC')
                @disciplinas = Disciplina.find(:all,:order => 'ordem ASC' )
           end
       end
    end
 end


end
