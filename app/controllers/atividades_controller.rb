class AtividadesController < ApplicationController
  # GET /atividades
  # GET /atividades.xml

 before_filter :load_dados_iniciais

  def load_dados_iniciais
    if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao')or current_user.has_role?('pedagogo')
          @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO" OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
          @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
          @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
          @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 2 or tipo_id = 3 or tipo_id = 4 or  tipo_id = 5  or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
    else
         @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
         @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ? and classes.unidade_id = ?' , Time.now.year,current_user.professor_id, current_user.unidade_id ], :order => 'classes.classe_classe ASC')
         #@unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
         @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4  or tipo_id = 7) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')

    end

  end


  def index
    @atividades = Atividade.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atividades }
    end
  end

  # GET /atividades/1
  # GET /atividades/1.xml
  def show
    @atividade = Atividade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atividade }
    end
  end

  # GET /atividades/new
  # GET /atividades/new.xml
  def new
    @atividade = Atividade.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atividade }
    end
  end

  # GET /atividades/1/edit
  def edit
    @atividade = Atividade.find(params[:id])
  end

  # POST /atividades
  # POST /atividades.xml
  def create
    @atividade = Atividade.new(params[:atividade])
    @atividade.classe_id= session[:ativ_classe_id]
    @atividade.atribuicao_id= session[:ativ_atribuicao_id]
    @atividade.ano_letivo =  Time.now.year
    @atividade.unidade_id =  current_user.unidade_id
    @atividade.user_id =  current_user.id
    respond_to do |format|
      if @atividade.save
        flash[:notice] = 'Atividade was successfully created.'
        format.html { redirect_to(@atividade) }
        format.xml  { render :xml => @atividade, :status => :created, :location => @atividade }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @atividade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /atividades/1
  # PUT /atividades/1.xml
  def update
    @atividade = Atividade.find(params[:id])

    respond_to do |format|
      if @atividade.update_attributes(params[:atividade])
        flash[:notice] = 'Atividade was successfully updated.'
        format.html { redirect_to(@atividade) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @atividade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /atividades/1
  # DELETE /atividades/1.xml
  def destroy
    @atividade = Atividade.find(params[:id])
    @atividade.destroy

    respond_to do |format|
      format.html { redirect_to(atividades_url) }
      format.xml  { head :ok }
    end
  end

  def classe

     w=session[:professor_id]=params[:atividade_professor_id]
     @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
   if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
       if @atribuicao.count > 1
           render :partial => 'disciplina'
       else
           session[:cont_atribuicao_id]=@atribuicao[0].id
           session[:cont_classe_id]= @atribuicao[0].classe_id
           render :partial => 'dados_classe'
       end
    end
  end

  def disciplina

 w=session[:ativ_disciplina_id] =  params[:disciplina_id]

 @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and id =?", session[:professor_id], Time.now.year, params[:disciplina_id] ])
 w1=session[:ativ_classe_id]= @atribuicao[0].classe_id
 w2=session[:ativ_atribuicao_id]=@atribuicao[0].id
 w3=session[:ativ_disciplina_id]=@atribuicao[0].disciplina_id
 t=0

        render :partial => 'dados_classe'
end


end
