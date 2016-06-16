class AtribuicaosController < ApplicationController
  # GET /atribuicaos
  # GET /atribuicaos.xml

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

  # GET /atribuicaos/1
  # GET /atribuicaos/1.xml
  def show
    @atribuicao = Atribuicao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atribuicao }
    end
  end

  # GET /atribuicaos/new
  # GET /atribuicaos/new.xml
  def new
    @atribuicao = Atribuicao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atribuicao }
    end
  end

  # GET /atribuicaos/1/edit
  def edit
    @atribuicao = Atribuicao.find(params[:id])
  end

  # POST /atribuicaos
  # POST /atribuicaos.xml
    def create
    @atribuicao = Atribuicao.new(params[:atribuicao])

    respond_to do |format|
      if @atribuicao.save
       session[:classe]= @atribuicao.classe_id
       session[:atribuicao]= @atribuicao.id
       session[:professor]= @atribuicao.professor_id
       @alunos1 = Aluno.find(:all, :joins => "INNER JOIN  alunos_classes  ON  alunos.id=alunos_classes.aluno_id  INNER JOIN classes ON classes.id=alunos_classes.classe_id", :conditions =>['classes.id = ?', session[:classe]])
       @alunos2 = Aluno.find(:all, :joins => "INNER JOIN transferencias ON alunos.id = transferencias.aluno_id INNER JOIN classes ON classes.id=transferencias.classe_id", :conditions=> ["transferencias.unidade_id = ? AND transferencias.classe_id=?  AND  alunos.unidade_id = ?", current_user.unidade_id, session[:classe], current_user.unidade_id, ])
       @alunos3= @alunos1+@alunos2
       if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
       for alun in @alunos3
         n=(params[:nota])
            @nota = Nota.new(params[:nota])
            @nota.aluno_id = alun.id
            @nota.atribuicao_id= session[:atribuicao]
            @nota.professor_id= session[:professor]
            @nota.unidade_id= current_user.unidade_id
            @nota.ano_letivo =  Time.now.year
            @nota.nota1 = nil
            @nota.faltas1 = nil
            @nota.nota2 = nil
            @nota.faltas2 = nil
            @nota.nota3 = nil
            @nota.faltas3 = nil
            @nota.nota4 = nil
            @nota.faltas4 = nil
            @nota.nota5 = nil
            @nota.faltas5= nil

              if @nota.save
                 flash[:notice] = 'DADOS SALVOS COM SUCESSO!'
              end
         end
       end
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@atribuicao) }
        format.xml  { render :xml => @atribuicao, :status => :created, :location => @atribuicao }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
      end
    end
  end
  # PUT /atribuicaos/1
  # PUT /atribuicaos/1.xml
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

  # DELETE /atribuicaos/1
  # DELETE /atribuicaos/1.xml
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
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )

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
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       @notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
       #@alunos1 = Aluno.find(:all, :joins => [:alunos_classe, :classe], :conditions =>['classes.id = ?', params[:classe][:id]])
       @alunos1 = Aluno.find(:all, :joins => "INNER JOIN  alunos_classes  ON  alunos.id=alunos_classes.aluno_id  INNER JOIN classes ON classes.id=alunos_classes.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]], :order => 'aluno_nome')
       @alunos2 = Aluno.find(:all, :joins => [:transferencias], :conditions=> ["transferencias.unidade_id = ? AND transferencias.classe_id=?", current_user.unidade_id, params[:classe][:id]], :order => 'aluno_nome')
       @alunos3= @alunos1+@alunos2
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
       @aluno = Aluno.find(:all,:conditions =>['id = ?', params[:aluno_aluno_id]])
       session[:aluno] =params[:aluno_aluno_id]
       @classeAtribuicaos = AlunosClasse.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno],Time.now.year ])
       @classeAtribuicaos.each do |classe|
         session[:classe]=classe.classe_id
       end
      @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
      @classe.each do |classe|
         session[:unidade]=classe.unidade_id
       end
       #@notas = Nota.find(:all,:conditions => ['aluno_id =? and ano_letivo =?', session[:aluno], Time.now.year])
      @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =? ", params[:aluno_aluno_id]],:order =>'disciplinas.ordem ASC ')

      #@notas = Nota.find(:all,:conditions => ['aluno_id =?', params[:aluno_aluno_id]])
      render :partial => 'relatorio_aluno'
end


def relatorio_classe
if ( params[:disciplina].present?)
      @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
        for dis in @disci
            session[:disc_id] = dis.id
        end
       session[:classe_id] = params[:classe][:id]

       @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]])
       #@alunos1 = Aluno.find(:all, :joins => [:alunos_classe, :classe], :conditions =>['classes.id = ?', params[:classe][:id]])

       #@users_admin = User.all(:joins => ' INNER JOIN roles_users         ON  users.id=roles_users.user_id      INNER JOIN roles   ON roles.id=roles_users.role_id', :conditions => ["roles.name = 'administrador' or users.id = ?", current_user.id])
# if (params[:search].present?)
 #      @chamados = Chamado.find(:all, :conditions => ["id = ?",  params[:search]])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classes }
    end
  end


def impressao_relatorio_aluno

       @aluno = Aluno.find(:all,:conditions =>['id = ?', session[:aluno]])
       @classeAtribuicaos = AlunosClasse.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno],Time.now.year ])
       @classeAtribuicaos.each do |classe|
         session[:classe]=classe.classe_id
       end
      @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
      @classe.each do |classe|
         session[:unidade]=classe.unidade_id
       end
      #@notas = Nota.find(:all,:conditions => ['aluno_id =? and ano_letivo =?', session[:aluno], Time.now.year])
      #@notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =? ", session[:aluno]],:order =>'disciplinas.ordem ASC ')
      @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =? ", session[:aluno]],:order =>'disciplinas.ordem ASC ')
      t=0
      render :layout => "impressao"
end

#     BOLETIM ESCOLAR   BOLETIM ESCOLAR   BOLETIM ESCOLAR
def relatorio_aluno_classe

       session[:classe_id] = params[:classe_id]

       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe_id]])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =? AND classe_id=?',current_user.unidade_id,  params[:classe_id]] )
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  params[:classe_id]],:order =>'disciplinas.ordem ASC ')
       @alunos1 = Aluno.find(:all, :joins => "inner join alunos_classes on alunos.id = alunos_classes.aluno_id", :conditions =>['alunos_classes.classe_id =?', params[:classe_id]],:order =>'aluno_nome')
       @alunos2 = Aluno.find(:all, :joins => [:transferencias], :conditions=> ["transferencias.unidade_id = ? AND transferencias.classe_id=?", current_user.unidade_id, params[:classe_id]], :order => 'aluno_nome')
       @alunos=   @alunos1 + @alunos2
    render :partial => 'relatorio_classe'

end

def impressao_relatorio_classe

       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe]])
       #@notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? ",  params[:classe_id]],:order =>'alunos.aluno_nome ASC')
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  session[:classe]],:order =>'disciplinas.ordem ASC ')
       @alunos1 = Aluno.find(:all, :joins => "inner join alunos_classes on alunos.id = alunos_classes.aluno_id", :conditions =>['alunos_classes.classe_id =?', session[:classe]],:order =>'aluno_nome')
       @alunos2 = Aluno.find(:all, :joins => [:transferencias], :conditions=> ["transferencias.unidade_id = ? AND transferencias.classe_id=?", current_user.unidade_id, session[:classe]], :order => 'aluno_nome')
       @alunos=   @alunos1 + @alunos2


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
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       @notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
       #@alunos1 = Aluno.find(:all, :joins => [:alunos_classe, :classe], :conditions =>['classes.id = ?', params[:classe][:id]])
       @alunos1 = Aluno.find(:all, :joins => "INNER JOIN  alunos_classes  ON  alunos.id=alunos_classes.aluno_id  INNER JOIN classes ON classes.id=alunos_classes.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]])
       @alunos2 = Aluno.find(:all, :joins => "INNER JOIN transferencias ON alunos.id = transferencias.aluno_id INNER JOIN classes ON classes.id=transferencias.classe_id", :conditions=> ["transferencias.unidade_id = ? AND transferencias.classe_id=?  AND  alunos.unidade_id = ?", current_user.unidade_id, params[:classe][:id], current_user.unidade_id, ])
       @alunos3= @alunos1+@alunos2

    render :layout => "impressao"
end


def mapa_de_classe
       session[:classe_id] = params[:classe][:id]
       t=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  params[:classe][:id]], :order => 'nome')

       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =? AND classe_id=?',current_user.unidade_id,  params[:classe][:id]] )
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  params[:classe][:id]],:order =>'disciplinas.ordem ASC')
       @alunos1 = Aluno.find(:all, :joins => "inner join alunos_classes on alunos.id = alunos_classes.aluno_id", :conditions =>['alunos_classes.classe_id =?', params[:classe][:id]],:order =>'aluno_nome')
       @alunos2 = Aluno.find(:all, :joins => [:transferencias], :conditions=> ["transferencias.unidade_id = ? AND transferencias.classe_id=?", current_user.unidade_id, params[:classe][:id]], :order => 'aluno_nome')
       @alunos=   @alunos1 + @alunos2
       @disciplinas= Disciplina.find(:all)
   t=0
           render :update do |page|
              page.replace_html 'mapa', :partial => 'mapa'
           end


end

def impressao_lencol

t=0
       t=session[:classe_id]
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id] ])
       t1=0
       @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id] ], :order => 'nome')
       t2=0
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe_id] ])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =? AND classe_id=?',current_user.unidade_id,  session[:classe_id] ] )
       @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["atribuicaos.classe_id =? ",  session[:classe_id] ],:order =>'disciplinas.ordem ASC')
       @alunos1 = Aluno.find(:all, :joins => "inner join alunos_classes on alunos.id = alunos_classes.aluno_id", :conditions =>['alunos_classes.classe_id =?', session[:classe_id]],:order =>'aluno_nome')
       @alunos2 = Aluno.find(:all, :joins => [:transferencias], :conditions=> ["transferencias.unidade_id = ? AND transferencias.classe_id=?", current_user.unidade_id, session[:classe_id] ], :order => 'aluno_nome')
       @alunos=   @alunos1 + @alunos2
       @disciplinas= Disciplina.find(:all)
   t=0

  render :layout => "impressao"

end

def historico_aluno
     @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
     for aluno in @aluno
       session[:unidade_id]= aluno.unidade_id
       session[:aluno_id]= aluno.id
     end
     @unidade = Unidade.find(:all, :conditions => ['id =?', session[:unidade_id]])
     @disciplinas = Disciplina.find(:all, :conditions =>['id < 22'],:order => 'ordem ASC' )

      @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
    
     #@alunos1 = Aluno.find(:all, :joins => "INNER JOIN  alunos_classes  ON  alunos.id=alunos_classes.aluno_id  INNER JOIN classes ON classes.id=alunos_classes.classe_id", :conditions =>['classes.id = ?', session[:classe]])
     #@disciplinas = Disciplina.find(:all, :joins => "INNER JOIN  notas  ON  disciplinas.id=notas.disciplina_id  INNER JOIN alunos ON alunos.id=notas.aluno_id", :conditions =>['disciplinas.id < 22 AND notas.aluno_id =?',session[:aluno_id] ],:order => 'disciplinas.ordem ASC,notas.ano_letivo ASC' )
     t=0
       render :update do |page|
          page.replace_html 'historico', :partial => 'notas_historico'
       end

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
     @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =? ", params[:aluno][:aluno_id]],:order =>'disciplinas.ordem ASC ')
     

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


   def load_professores11
    @professores1 = type_user(current_user.unidade_id)
  end

  def load_professores1
    if  (current_user.unidade_id == 53) or (current_user.unidade_id == 100)
      # type = 53 => usuário administrativo
      @professores1 = Professore.find(:all, :conditions =>  ["desligado=0"], :order => 'nome ASC')
    else
      if unit == 99
        # type = 99 => usuário itinerante
        #@regiao = Regiao.all
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
      #@classes = Classe.find(:all, :select => 'count(distinct(classe_classe))', :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.professor_id = ?', current_user.professor_id])
      #@classes = Classe.find(:all, :select => 'distinct(classe_classe) ', :joins => :atribuicaos, :conditions => ['unidade_id = ? and classe_ano_letivo = ? and atribuicaos.professor_id = ?', current_user.unidade_id, Time.now.year, current_user.professor_id  ], :order => 'classe_classe ASC')
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
          #    @disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id ="+ (current_user.professor_id).to_s+" AND atribuicaos.ano_letivo = "+Time.now.year.to_s)

      end
       # @disciplinas1 = Disciplina.find_(:all, :joins => :atribuicao, :conditions => ['atribuicaos.ano_letivo = ?  and atribuicaos.professor_id = ?',  Time.now.year, current_user.professor_id  ])

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
        @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ? AND desligado = 0', current_user.unidade_id],:order => 'nome ASC')

        @alunos1 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
        @alunos3 = Aluno.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id],:order => 'aluno_nome ASC' )
        #disciplinas1 = Disciplina.find_(:all, :joins => :atribuicao, :conditions => ['atribuicaos.ano_letivo = ?  and atribuicaos.professor_id = ?',  Time.now.year, current_user.professor_id  ])
        #@alunos1 = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
        @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )

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
