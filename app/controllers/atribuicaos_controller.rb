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

    def create_notas
 n=(params[:nota])
      @nota = Nota.new(params[:nota])
      @nota.ano_letivo =  Time.now.year
      @nota.atribuicao_id= session[:id]
      @nota.aluno_id= session[:aluno]
      @nota.professor_id= session[:professor_id]

      if @nota.save
        @notas = Nota.all(:conditions => ["atribuicao_id is null"])
        t=0
        session[:nota_id] = @nota.id
         render :update do |page|
            page.replace_html 'notas_aluno', :partial => "notas"
        end
      end
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
        @classes = Classe.find(:all, :order => 'classe_classe ASC')
    else
      @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
      #@classes = Classe.find(:all, :select => 'count(distinct(classe_classe))', :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.professor_id = ?', current_user.professor_id])
      #@classes = Classe.find(:all, :select => 'distinct(classe_classe) ', :joins => :atribuicaos, :conditions => ['unidade_id = ? and classe_ano_letivo = ? and atribuicaos.professor_id = ?', current_user.unidade_id, Time.now.year, current_user.professor_id  ], :order => 'classe_classe ASC')
      @disciplinas1 = Disciplina.find_by_sql("SELECT DISTINCT disciplinas.disciplina  FROM disciplinas INNER JOIN atribuicaos ON atribuicaos.disciplina_id = disciplinas.id WHERE atribuicaos.professor_id =1326 AND atribuicaos.ano_letivo = "+Time.now.year.to_s)

       # @disciplinas1 = Disciplina.find_(:all, :joins => :atribuicao, :conditions => ['atribuicaos.ano_letivo = ?  and atribuicaos.professor_id = ?',  Time.now.year, current_user.professor_id  ])

    end
 end

   def load_professors
    if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @professors = Professor.find(:all, :order => 'nome ASC')
    else
        @professors1 = Professor.find(:all, :conditions => ['id = ?', current_user.professor_id  ],:order => 'nome ASC')
        @professors = Professor.find(:all, :order => 'nome ASC')
        @alunos1 = Aluno.find(:all,  :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.professor_id = ?', current_user.professor_id])
    end
  end

   def load_disciplinas

        @disciplinas = Disciplina.find(:all,:order => 'disciplina ASC')

  end

end
