class AtribuicaosController < ApplicationController

 before_filter :load_professors
  before_filter :load_classes
    before_filter :load_disciplinas



  def index
    @atribuicaos = Atribuicao.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atribuicaos }
    end
  end

  def show
    @atribuicao = Atribuicao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atribuicao }
    end
  end

  def new
    @atribuicao = Atribuicao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atribuicao }
    end
  end


  def edit
    @atribuicao = Atribuicao.find(params[:id])
  end

 def create
    @atribuicao = Atribuicao.new(params[:atribuicao])

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
  
  def update
    @atribuicao = Atribuicao.find(params[:id])

    respond_to do |format|
      if @atribuicao.update_attributes(params[:atribuicao])
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@atribuicao) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def destroy

    @atribuicao = Atribuicao.find(params[:id])
    @atribuicao.destroy

    respond_to do |format|
      format.html { redirect_to(atribuicaos_url) }
      format.xml  { head :ok }
    end
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
       @aluno = Aluno.find(:all,:conditions =>['id = ? AND aluno_status is null', params[:aluno_aluno_id]])
       session[:aluno] =params[:aluno_aluno_id]
       @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno],Time.now.year ])
       @matriculas.each do |matricula|
         session[:classe]=matricula.classe_id
         session[:num]=matricula.classe_num
       end
      @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
      @classe.each do |classe|
         session[:unidade]=classe.unidade_id
       end
      @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
      @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year   ],:order =>'disciplinas.ordem ASC ')
      @notas = @notasB+@notasD
      render :partial => 'relatorio_aluno'

end


def relatorio_classe
if ( params[:disciplina].present?)
      @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
        for dis in @disci
            session[:disc_id] = dis.id
        end
       session[:classe_id] = params[:classe][:id]
       t1=session[:classe_id]

       @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
       @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classes }
    end
  end


def impressao_relatorio_aluno
  t2= session[:classe]
       @aluno = Aluno.find(:all,:conditions =>['id = ?', session[:aluno]])
       @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno],Time.now.year ])
       @matriculas.each do |classe|
         session[:classe]=classe.classe_id
       end
       @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
       @classe.each do |classe|
         session[:unidade]=classe.unidade_id
       end
       @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL", session[:aluno], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
       @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL", session[:aluno], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
       @notas = @notasB+@notasD

      render :layout => "impressao"
end

#     BOLETIM ESCOLAR   BOLETIM ESCOLAR   BOLETIM ESCOLAR
def relatorio_aluno_classe

       t6= session[:classe_id] = params[:classe_id]
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe_id]], :order =>'classe_num')
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe_id]])
       @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =?   AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?", params[:classe_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
       @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =?   AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?", params[:classe_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
       @notas = @notasB+@notasD
       t=0
    render :partial => 'relatorio_classe'

end

def impressao_relatorio_classe
       t5=session[:classe_id]
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order =>'classe_num')
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe_id]])
       @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =?   AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?", session[:classe_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
       @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =?   AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?", session[:classe_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
       @notas = @notasB+@notasD
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


def mapa_de_classe
       session[:classe_id] = params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  params[:classe][:id]], :order => 'nome')
       @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', params[:classe][:id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  params[:classe][:id]],:order =>'disciplinas.ordem ASC')
       @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', params[:classe][:id]],:order =>'aluno_nome')
       @disciplinas= Disciplina.find(:all)
              render :update do |page|
              page.replace_html 'mapa', :partial => 'mapa'
           end
end

def impressao_lencol1
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id] ])
       @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id] ], :order => 'nome')
       @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  session[:classe_id] ],:order =>'disciplinas.ordem ASC')
       @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', session[:classe_id]],:order =>'aluno_nome')
       @disciplinas= Disciplina.find(:all)
  render :layout => "impressao"
end

def impressao_lencol2
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id] ])
       @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id] ], :order => 'nome')
       @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  session[:classe_id] ],:order =>'disciplinas.ordem ASC')
       @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', session[:classe_id]],:order =>'aluno_nome')
       @disciplinas= Disciplina.find(:all)
  render :layout => "impressao"
end

def impressao_lencol3
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id] ])
       @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id] ], :order => 'nome')
       @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  session[:classe_id] ],:order =>'disciplinas.ordem ASC')
       @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', session[:classe_id]],:order =>'aluno_nome')
       @disciplinas= Disciplina.find(:all)
  render :layout => "impressao"
end






def historico_aluno
     @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
     for aluno in @aluno
       t2=session[:unidade_id]= aluno.unidade_id
       t1=session[:aluno_id]= aluno.id
     end
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


def transferenciaA
  
end

def transferencia_aluno

     @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
     session[:aluno_id]=params[:aluno][:aluno_id]
     for aluno in @aluno
       session[:unidade_id]= aluno.unidade_id
       session[:aluno_id]= aluno.id
     end
     @classe = Classe.find(:all, :joins => "inner join alunos_classes on classes.id = alunos_classes.classe_id", :conditions =>['alunos_classes.aluno_id =? AND ano_letivo=?' , params[:aluno][:aluno_id], Time.now.year])
     @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =?",  params[:aluno][:aluno_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC ')
     @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =?",  params[:aluno][:aluno_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC ')
     @notas = @notasB+@notasD
       render :update do |page|
          page.replace_html 'transferencia', :partial => 'transferencia'
       end
end

def impressao_transferencia_aluno
       @aluno = Aluno.find(:all, :conditions => ['id =?', session[:aluno_id]])
     for aluno in @aluno
       session[:unidade_id]= aluno.unidade_id
       session[:aluno_id]= aluno.id
     end
     @classe = Classe.find(:all, :joins => "inner join alunos_classes on classes.id = alunos_classes.classe_id", :conditions =>['alunos_classes.aluno_id =? AND ano_letivo=?' , session[:aluno_id], Time.now.year])
     @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =? ", session[:aluno_id]],:order =>'disciplinas.ordem ASC ')
     render :layout => "impressao"
end



def reserva_vaga
     @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
     session[:aluno_id]=params[:aluno][:aluno_id]
     for aluno in @aluno
       session[:unidade_id]= aluno.unidade_id
       session[:aluno_id]= aluno.id
     end
     @classe = Classe.find(:all, :joins => "inner join alunos_classes on classes.id = alunos_classes.classe_id", :conditions =>['alunos_classes.aluno_id =? AND ano_letivo=?' , params[:aluno][:aluno_id], Time.now.year])
       render :update do |page|
          page.replace_html 'documento', :partial => 'reserva_vaga'
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
        @professors1 = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
        @professor_unidade = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
        @alunos1 = Aluno.find(:all,:order => 'aluno_nome ASC' )
        @alunos3 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
    else
        @professors1 = Professor.find(:all, :conditions => ['id = ? AND desligado = 0', current_user.professor_id  ],:order => 'nome ASC')
        @professors = Professor.find(:all, :conditions => 'desligado = 0', :order => 'nome ASC')
        @professor_unidade = Professor.find(:all, :conditions => ['(unidade_id = ? or unidade_id = 52 or unidade_id = 54) AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
        @alunos1 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
        @alunos3 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
        @alunos_boletim = @alunos1
     end
  end


   def load_disciplinas

      if current_user.professor_id.nil?
          if current_user.unidade_id < 42 or current_user.unidade_id > 53
              @disciplinas = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
              @nota=Nota.find(62)
          else
              @disciplinas = Disciplina.find(:all, :conditions => ["id < 26 or id > 27"])
              @nota=Nota.find(62)
          end

      else
          if current_user.unidade_id < 42 or current_user.unidade_id > 53
              @disciplinas = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
              @nota=Nota.find(62)
          else
            @disciplinas = Disciplina.find(:all, :conditions => ["id != 27 and id !=26"])
            @nota=Nota.find(62)
          end
      end

  end

end
