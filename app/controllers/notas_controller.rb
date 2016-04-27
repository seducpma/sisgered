class NotasController < ApplicationController
  # GET /notas
  # GET /notas.xml
before_filter :load_classes




  def index
    @notas = Nota.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notas }
    end
  end

  # GET /notas/1
  # GET /notas/1.xml
  def show
    @nota = Nota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/new
  # GET /notas/new.xml
  def new
    @nota = Nota.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/1/edit
  def edit
    @nota = Nota.find(params[:id])
  end

  # POST /notas
  # POST /notas.xml
  def create
    @nota = Nota.new(params[:nota])

    respond_to do |format|
      if @nota.save
        flash[:notice] = 'Nota was successfully created.'
        format.html { redirect_to(@nota) }
        format.xml  { render :xml => @nota, :status => :created, :location => @nota }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notas/1
  # PUT /notas/1.xml
  def update
    @nota = Nota.find(params[:id])

    respond_to do |format|
      if @nota.update_attributes(params[:nota])
        flash[:notice] = 'Nota was successfully updated.'
        format.html { redirect_to(@nota) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notas/1
  # DELETE /notas/1.xml
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
      t1=params[:notas_aluno]

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
       #@alunos1 = Aluno.find(:all, :joins => [:alunos_classe, :classe], :conditions =>['classes.id = ?', params[:classe][:id]])
       @alunos1 = Aluno.find(:all, :joins => "INNER JOIN  alunos_classes  ON  alunos.id=alunos_classes.aluno_id  INNER JOIN classes ON classes.id=alunos_classes.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]])
       #@users_admin = User.all(:joins => ' INNER JOIN roles_users         ON  users.id=roles_users.user_id      INNER JOIN roles   ON roles.id=roles_users.role_id', :conditions => ["roles.name = 'administrador' or users.id = ?", current_user.id])
# if (params[:search].present?)
 #      @chamados = Chamado.find(:all, :conditions => ["id = ?",  params[:search]])
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
       @notas = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'notas.bimestre ASC, alunos.aluno_nome ASC')
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
       @notas = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?", session[:classe_id], session[:professor_id], session[:disc_id]],:order => 'notas.bimestre ASC, alunos.aluno_nome ASC')
render :layout => "impressao"

end

def impressao_lancamentos_notas
 
       @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?',session[:classe_id], session[:professor_id], session[:disc_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?',session[:classe_id], session[:professor_id], session[:disc_id]])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       @notas = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?", session[:classe_id], session[:professor_id], session[:disc_id]],:order => 'notas.bimestre ASC, alunos.aluno_nome ASC')
 
render :layout => "impressao"

end


 def load_classes
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classes = Classe.find(:all, :order => 'classe_classe ASC')
        @disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id =1326 AND atribuicaos.ano_letivo = "+Time.now.year.to_s)
        @professors1 = Professor.find(:all, :order => 'nome ASC')

    else
        @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        @disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id =1326 AND atribuicaos.ano_letivo = "+Time.now.year.to_s)
        @professors1 = Professor.find(:all, :conditions => ['id = ?', current_user.professor_id  ],:order => 'nome ASC')
    end
 end


end
