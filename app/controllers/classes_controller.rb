class ClassesController < ApplicationController

  before_filter :load_professors
  before_filter :load_classes
  before_filter :load_alunos
  


  def index
    @classes = Classe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classes }
    end
  end

  def show
    @classe = Classe.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @class }
    end
  end

  def new
    @classe = Classe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @classe }
    end
  end


  def edit
    @classe = Classe.find(params[:id])
    session[:classe_id]=(params[:id])
    @alunos_selecionados = @classe.alunos
    @alunos = @alunos - @alunos_selecionados

  end

  def create
    @classe = Classe.new(params[:classe])
    respond_to do |format|
      if @classe.save
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classe) }
        format.xml  { render :xml => @classe, :status => :created, :location => @classs }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @classe.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @alunosA = Aluno.find(:all,:joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', session[:classe_id]])
    @classe = Classe.find(params[:id])
    respond_to do |format|
      if @classe.update_attributes(params[:classe])
       @alunosD = Aluno.find(:all,:joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', session[:classe_id]])
       @aluno = @alunosD -@alunosA
       for aluno in @aluno
          session[:id_aluno]= aluno.id
          session[:classe]= @classe.id
          @atribuicao= Atribuicao.find(:all, :conditions=>['classe_id=? AND ativo=?', @classe.id, 0 ])
          for atrib in @atribuicao
           session[:classe]= atrib.classe_id
           session[:atribuicao]= atrib.id
           session[:disciplina]= atrib.disciplina_id
           session[:professor]= atrib.professor_id
           @alunos1 = Aluno.find(:all, :joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', session[:classe]])
           @aluno3 = Aluno.find(:all, :conditions => ['id = ?', session[:id_aluno]])
           if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
           for alun in @aluno3
             n=(params[:nota])
                @nota = Nota.new(params[:nota])
                @nota.aluno_id = alun.id
                @nota.disciplina_id = session[:disciplina]
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
                @nota.save
              end
            end
          end
         end
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classe) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @classe.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @classe = Classe.find(params[:id])
    @classe.destroy

    respond_to do |format|
      format.html { redirect_to(home_path) }
      format.xml  { head :ok }
    end
  end


def destroy_classe_aluno
  aluno_id=params[:id]
  classe_id= session[:classe_id]
  @classe =Classe.find(session[:classe_id])
  results = ActiveRecord::Base.connection.execute("DELETE FROM `matriculas` WHERE `aluno_id`="+(aluno_id).to_s+ " and classe_id="+(classe_id).to_s)

end

def destroy_classe_professor
  professor_id=params[:id]
  classe_id= session[:classe_id]
  @classe =Classe.find(session[:classe_id])
  results = ActiveRecord::Base.connection.execute("DELETE FROM `classes_professors` WHERE `professor_id`="+(professor_id).to_s + " and classe_id="+(classe_id).to_s)
end

  def seleciona_montar_classe
    @classe1 = Classe.find(:all, :conditions => ['id= ?',params[:classe_id]])
  
    render :partial => 'dados_classe'
  end


  def load_professors
    if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @professors = Professor.find(:all,:conditions =>'desligado = 0', :order => 'nome ASC')
    else
        @professors = Professor.find(:all, :conditions => ['desligado = 0 AND (unidade_id = ? or unidade_id = 54)', current_user.unidade_id  ],:order => 'matricula ASC')
    end
  end


def consulta_classe_aluno

       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')

        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end

def consulta_piloto

       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_piloto'
       end
end

def editar_classe_aluno
       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe_editar'
       end
end


 def destroy_professor
   t=(params[:id])
    @atribuicao = Atribuicao.find(params[:id])

    @atribuicao.destroy

    respond_to do |format|
      format.html { redirect_to(home_path) }
      format.xml  { head :ok }
    end
  end

def impressao_classe
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id], 0])
       t1=session[:classe_id]

       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',  session[:classe_id]], :order => 'classe_num ASC')
      render :layout => "impressao"
end


def impressao_piloto
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
       render :layout => "impressao"
end

def impressao_lista
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',  session[:classe_id]], :order => 'classe_num ASC')

      render :layout => "impressao"
end

def consulta_lista_classe
       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')

        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_lista'
       end
end

  def classes_ano

        @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id]    )

   
   render :partial => 'selecao_classe'
  end



 def load_classes
  @ano =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo ASC')
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classe = Classe.find(:all, :order => 'classe_classe ASC')
        @classe_todas =  Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        @classe_todas =  Classe.find(:all, :conditions => ['unidade_id = ? ', current_user.unidade_id  ], :order => 'classe_ano_letivo ASC, classe_classe ASC')
        @classe_td =  Classe.find(:all,:select => 'distinct(classe_ano_letivo)',:order => 'classe_ano_letivo ASC')

    end
 end


  def load_alunos
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @alunos = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `id`not in (SELECT matriculas.aluno_id FROM classes INNER JOIN matriculas ON classes.id = matriculas.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+") ORDER BY aluno_nome ASC")
    else
        unidade=  current_user.unidade_id
        @alunos = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `unidade_id`= "+unidade.to_s+" AND`id`not in (SELECT matriculas.aluno_id FROM classes INNER JOIN matriculas ON classes.id = matriculas.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")ORDER BY aluno_nome ASC")
    end

 end
end
