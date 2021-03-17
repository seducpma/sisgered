class FaltasalunosController < ApplicationController
  # GET /faltasalunos
  # GET /faltasalunos.xml
 before_filter :load_dados_iniciais

    def load_dados_iniciais
        if current_user.has_role?('admin') or current_user.has_role?('SEDUC')
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO" OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
            @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
            @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
            @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 2 or tipo_id = 3 or tipo_id = 4 or  tipo_id = 5  or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
        else if current_user.has_role?('direcao_fundamental')  or current_user.has_role?('pedagogo')or current_user.has_role?('supervisao')
                @professor_unidade = Professor.find(:all,:select => "distinct(professors.nome), professors.id", :joins => "INNER JOIN  atribuicaos   ON  professors.id = atribuicaos.professor_id INNER JOIN  classes   ON  classes.id = atribuicaos.classe_id ", :conditions => ['classes.unidade_id = ?  AND professors.desligado = 0 and atribuicaos.ano_letivo =?', current_user.unidade_id, Time.now.year],:order => 'nome ASC')
             else
                @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
                @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ? and classes.unidade_id = ?' , Time.now.year,current_user.professor_id, current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                #@unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4  or tipo_id = 7) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
             end
        end
    end


 def alunos
    session[:classe_id]= params[:classe_id]
     @alunos_matriculados = Aluno.find(:all, :select => "alunos.id , CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn  , matriculas.classe_num as numero"  , :joins => "INNER JOIN matriculas on alunos.id = matriculas.aluno_id", :conditions => ["matriculas.classe_id = ? AND matriculas.ano_letivo =? and ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND alunos.unidade_id = ?", session[:classe_id], Time.now.year , current_user.unidade_id ],:order => 'classe_num ASC' )
        render :partial => 'alunos'
end

 def data
   session[:dia]= params[:faltasalunos_data]

 end
  def disciplina
   session[:disciplina_id]= params[:disciplina_id]
   
 end

 def faltas
   session[:falta]= params[:falta]
   
 end

 def obser
    wwww=session[:obser]=params[:aluno_nome]
    t=0

 end
def alunos_faltas_falta
 
     @alunos_faltaram=  Aluno.find(params[:aluno_ids], :order => 'aluno_nome ASC')
     @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and classe_id=? and disciplina_id =?", session[:professor_id], Time.now.year , session[:classe_id], session[:disciplina_id]])
     for aluno in @alunos_faltaram
          @faltasaluno = Faltasaluno.new
           @matricula= Matricula.find(:all, :conditions=> ['aluno_id=? and classe_id=?', aluno.id, session[:classe_id]])   # precisa também verificar o estado da matricula
           @faltasaluno.aluno_id = aluno.id
           @faltasaluno.matricula_id=@matricula[0].id
           @faltasaluno.atribuicao_id=@atribuicao[0].id
           @faltasaluno.professor_id=session[:professor_id]
           @faltasaluno.unidade_id=@matricula[0].unidade_id
           @faltasaluno.disciplina_id=session[:disciplina_id]
           @faltasaluno.user_id=current_user.id
           @faltasaluno.classe_id=session[:classe_id]
           @faltasaluno.ano_letivo = Time.now.year
           @faltasaluno.data=session[:dia]
           @faltasaluno.faltas=session[:falta]
           @faltasaluno.obs=session[:obser]
           @faltasaluno.save

     end
 
end

def classe
   session[:professor_id]=params[:professor_id]

   session[:data]= params[:data]
   
  
   @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
 
    if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
        @classes = Classe.find(:all, :select => "disciplinas.id as disc_id, classes.unidade_id,  atribuicaos.disciplina_id as disciplina,  classes.id as classe_id, CONCAT(classes.classe_classe, ' - ',disciplinas.disciplina,' - ',unidades.nome) AS classe", :joins => "INNER JOIN atribuicaos on classes.id = atribuicaos.classe_id INNER JOIN disciplinas on disciplinas.id = atribuicaos.disciplina_id INNER JOIN unidades ON unidades.id = classes.unidade_id" ,:conditions => ['disciplinas.nao_disciplina = 0 AND atribuicaos.professor_id = ? AND atribuicaos.ano_letivo =?', session[:professor_id], Time.now.year ],:order => 'disciplina ASC' )
        render :partial => 'classe'
    end
  end

    def lancar_faltas_diario

    end

  def index
    @faltasalunos = Faltasaluno.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @faltasalunos }
    end
  end

  # GET /faltasalunos/1
  # GET /faltasalunos/1.xml
  def show
    @faltasaluno = Faltasaluno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @faltasaluno }
    end
  end

  # GET /faltasalunos/new
  # GET /faltasalunos/new.xml
  def new
    @faltasaluno = Faltasaluno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @faltasaluno }
    end
  end

  # GET /faltasalunos/1/edit
  def edit
    @faltasaluno = Faltasaluno.find(params[:id])
  end

  # POST /faltasalunos
  # POST /faltasalunos.xml
  def create
    @faltasaluno = Faltasaluno.new(params[:faltasaluno])
t=0
    respond_to do |format|
      if @faltasaluno.save
        flash[:notice] = 'Faltasaluno was successfully created.'
        format.html { redirect_to(@faltasaluno) }
        format.xml  { render :xml => @faltasaluno, :status => :created, :location => @faltasaluno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @faltasaluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /faltasalunos/1
  # PUT /faltasalunos/1.xml
  def update
    @faltasaluno = Faltasaluno.find(params[:id])

    respond_to do |format|
      if @faltasaluno.update_attributes(params[:faltasaluno])
        flash[:notice] = 'Faltasaluno was successfully updated.'
        format.html { redirect_to(@faltasaluno) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @faltasaluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /faltasalunos/1
  # DELETE /faltasalunos/1.xml
  def destroy
    @faltasaluno = Faltasaluno.find(params[:id])
    @faltasaluno.destroy

    respond_to do |format|
      format.html { redirect_to(faltasalunos_url) }
      format.xml  { head :ok }
    end
  end
end
