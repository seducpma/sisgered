class RegistrosController < ApplicationController
  # GET /registros
  # GET /registros.xml

before_filter :load_dados_iniciais
   def load_dados_iniciais
     session[:cont_usuario_user_id]= current_user.unidade_id
     session[:cont_professor_user_id]= current_user.professor_id
       if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao')or current_user.has_role?('pedagogo')
         if current_user.has_role?('pedagogo')
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO"  )'],:order => 'nome ASC')
         else
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND ( classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
         end
            @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
            @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
            @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 2 or tipo_id = 3 or tipo_id = 4 or  tipo_id = 5  or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')

       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
             @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ?' , Time.now.year,current_user.professor_id ], :order => 'classes.classe_classe ASC')
             @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 2 or  tipo_id = 5  or tipo_id = 8)'  ], :order => 'nome ASC')
              else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil') or    current_user.has_role?('pedagogo')
                  @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ', :conditions => ['desligado = 0 AND (funcao2="PEDAGOGO" OR funcao2="PROF. COORDENADOR" or funcao2="DIRETOR ED. BÁSICA"  or funcao2="DIRETOR INFANTIL")'],:order => 'nome ASC')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                   @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ? AND unidades.id = ?' , Time.now.year,current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                   @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 2 or  tipo_id = 5  or tipo_id = 8) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
                   else if current_user.has_role?('professor_fundamental')
                         @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
                         @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ? and classes.unidade_id = ?' , Time.now.year,current_user.professor_id, current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                         @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                         @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4  or tipo_id = 7) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
                         else if  current_user.has_role?('direcao_fundamental')   or    current_user.has_role?('secretaria_fundamental') or    current_user.has_role?('pedagogo')
                               @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ', :joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO" OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')

                               @professor_unidade = Professor.find(:all, :conditions => ['(unidade_id = ?) OR 	diversas_unidades = 1 AND desligado = 0 ', (current_user.unidade_id)],:order => 'nome ASC')
                                @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ? AND unidades.id = ?' , Time.now.year,current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                                @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                              end

                          end
                    end
              end
       end
  end

 def classe
 w=session[:professor_id]=params[:registro_professor_id]
t=0
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
    if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
       if @atribuicao.count > 1
          session[:atribuicao]=@atribuicao[0].classe_id
          w=@atribuicao[0].id
           teste= @atribuicao[0].classe.classe_classe[0,3]
          t=0
          if teste == 'AEE'
            w=session[:atribuicao]= 'AEE'
                 t=0
          end
           render :partial => 'disciplina'
       else
           session[:cont_atribuicao_id]=@atribuicao[0].id
           session[:cont_classe_id]= @atribuicao[0].classe_id
           @alunos= Aluno.find(:all, :joins => "INNER JOIN matriculas ON matriculas.aluno_id = alunos.id", :conditions => ["matriculas.classe_id =?  and ano_letivo=?", session[:cont_classe_id], Time.now.year ])
           render :partial => 'dados_classe'
       end
    end
 end


  def index
    @registros = Registro.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registros }
    end
  end

  # GET /registros/1
  # GET /registros/1.xml
  def show
    @registro = Registro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registro }
    end
  end

  # GET /registros/new
  # GET /registros/new.xml
  def new
    @registro = Registro.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registro }
    end
  end

  # GET /registros/1/edit
  def edit
    @registro = Registro.find(params[:id])
  end

  # POST /registros
  # POST /registros.xml
  def create
    @registro = Registro.new(params[:registro])

    respond_to do |format|
      if @registro.save
        flash[:notice] = 'Registro was successfully created.'
        format.html { redirect_to(@registro) }
        format.xml  { render :xml => @registro, :status => :created, :location => @registro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registros/1
  # PUT /registros/1.xml
  def update
    @registro = Registro.find(params[:id])

    respond_to do |format|
      if @registro.update_attributes(params[:registro])
        flash[:notice] = 'Registro was successfully updated.'
        format.html { redirect_to(@registro) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registros/1
  # DELETE /registros/1.xml
  def destroy
    @registro = Registro.find(params[:id])
    @registro.destroy

    respond_to do |format|
      format.html { redirect_to(registros_url) }
      format.xml  { head :ok }
    end
  end
end
