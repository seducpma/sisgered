class TituloProfessorsController < ApplicationController
  before_filter :load_titulacao
  before_filter :load_consulta_ano
  before_filter :load_professors
  before_filter :load_professors1
  before_filter :load_professors_consulta
  before_filter :professor_unidade
  before_filter :login_required
#  require_role ["supervisao","planejamento","administrador"], :for_all_except => [:search,:search_by_desc,:search_by_professor_titulos_anuais,:relatorio_titulos_anuais_invalidos,:relatorio_por_descricao_titulo, :relatorio_prof_titulacao,:update, :titulos_busca, :destroy, :index, :new, :create, :sel_prof, :busca_prof, :guarda_valor1, :guarda_valor, :nome_professor]
  # GET /titulo_professors
  # GET /titulo_professors.xml
  layout :define_layout

  def define_layout
      current_user.layout
  end
def consulta
  
end

def consulta_titulacao_professor
  
end


def consulta_titulacao_professor
   if (params[:search].nil? || params[:search].empty?)
      titulo = 0
      $titulo = 0
   else
      titulo = params[:search][:search]
      $titulo = params[:search][:search]
   end
    if $titulo != 0
           @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.titulo_id =?  ", $titulo] )
           #@tp = TituloProfessor.find(:all,  :conditions =>["titulo_professors.titulo_id =?  ", $titulo] )

    end
  end





  #Relatorio por tiulos

  def relatorio_prof_titulacao
    if (params[:titulo_id]).present?
    if (params[:accept]).present?
      @relatorio_tit_prof = TituloProfessor.paginate(:all, :page=>params[:page],:per_page =>20,:conditions => ["titulo_id <> ?",params[:titulo_id][:titulo_id]], :include => ['professor'],:order => 'professors.nome')
    else
      @relatorio_tit_prof = TituloProfessor.paginate(:all, :page=>params[:page],:per_page =>20,:conditions => ["titulo_id = ?", params[:titulo_id][:titulo_id]], :include => ['professor'],:order => 'professors.nome')
    end
   else
     @relatorio_tit_prof = "Selecione um titulo para filtragem"
   end
    render :action => 'relatorio_prof_titulacao'

  end

  def search
  end

#=====================================================================================================================================================================

# Relatorio pela descrição do titulo

  def relatorio_por_descricao_titulo

   if (params[:titulo]).present?
     #@relatorio_por_descricao_titulo = TituloProfessor.obs_like(params[:titulo])
     @relatorio_por_descricao_titulo = TituloProfessor.paginate(:all,:page=>params[:page],:per_page =>20,:conditions => ["obs like ? and titulo_id = 1",params[:titulo]])
   else
     @relatorio_por_descricao_titulo = "Descreva o titulo para filtragem"
   end
    render :action => 'relatorio_por_descricao_titulo'


  end

  def search_by_desc
  end


#====================================================================================================================================================================
# Relatorio titulos anuais invalidos

  def relatorio_titulos_anuais_invalidos
    if (params[:professor_id]).present?
     @relatorio_tit_prof = TituloProfessor.paginate(:all,:page=>params[:page],:per_page =>20,:conditions => ["professor_id = ? and (titulo_id = 6 or titulo_id = 7 or titulo_id = 8) and ano_letivo <> ?",params[:professor_id][:professor_id], Time.current.strftime("%Y")])
   else
     @relatorio_tit_prof = "Selecione o professor"
   end
    render :action => 'relatorio_titulos_anuais_invalidos'
  end

  def search_by_professor_titulos_anuais

  end

#====================================================================================================================================================================
  
  def index
    @titulo_professors = TituloProfessor.find(:all, :conditions => ['professor_id = ' + $teacher.to_s])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titulo_professors }
    end
  end

  # GET /titulo_professors/1
  # GET /titulo_professors/1.xml
  def show
    @titulo_professor = TituloProfessor.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @titulo_professor }
    end
  end

  # GET /titulo_professors/new
  # GET /titulo_professors/new.xml
  def new
    @titulo_professor = TituloProfessor.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @titulo_professor }
    end
  end

  # GET /titulo_professors/1/edit
  def edit
    @tp = TituloProfessor.find(params[:id])
  end

  # POST /titulo_professors
  # POST /titulo_professors.xml
  def create
    @titulo_professor = TituloProfessor.new(params[:titulo_professor])
    @titulo_professor.valor= $valor
    @titulo_professor.ano_letivo =Time.current.strftime("%Y")
    a=@titulo_professor.tipo_curso


    #@titulo_professor.user = current_user.id
    #@titulo_professor.current = Time.current
    y = @titulo_professor.tipo_curso
    #@titulo_professor.begin_period = "#{session[:begin_period]}"
    #@titulo_professor.end_period =  "#{session[:end_period]}"
    #@log = Log.new
    #@log.log(current_user.id, @titulo_professor.professor_id, "Cadastrado Titulo do professor.")

    respond_to do |format|
      if @titulo_professor.save
        flash[:notice] = 'TITULAÇÂO CADASTRADA COM SUCESSO.'
        format.html { redirect_to(@titulo_professor)}
        format.xml  { render :xml => @titulo_professor, :status => :created, :location => @titulo_professor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @titulo_professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /titulo_professors/1
  # PUT /titulo_professors/1.xml
  def update
    @titulo_professor = TituloProfessor.find(params[:id])
    @at_log = Log.new
    @at_log.titulacao_id = @titulo_professor.id
    @at_log.obs = "Atualizado"
    @at_log.professor_id = @titulo_professor.professor_id
    @at_log.user_id = current_user.id
    @at_log.save
    respond_to do |format|
      if @titulo_professor.update_attributes(params[:titulo_professor])
        flash[:notice] = 'TITULO ATUALIZADO COM SUCESSO'
        format.html { redirect_to(titulo_professor_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @titulo_professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /titulo_professors/1
  # DELETE /titulo_professors/1.xml
  def destroy
    $r =TituloProfessor.find(params[:id])
    @titulo_professor = TituloProfessor.find(params[:id])
    #@at_log = Log.new
    #@at_log.titulacao_id = @titulo_professor.id
    #@at_log.obs = "Atualizado"
    #@at_log.professor_id = @titulo_professor.professor_id
    #@at_log.user_id = current_user.id
    #@at_log.save
    @titulo_professor.destroy

    respond_to do |format|
      format.html { redirect_to(new_titulo_professor_path) }
      format.xml  { head :ok }
    end
  end


  def sel_prof
    $teacher = params[:titulo_professor_professor_id]
    session[:teacher] = params[:titulo_professor_professor_id]

    if !($teacher.nil? or $teacher.empty?) or $teacher == '' then
      if (Professor.find($teacher)).nil? then
         render :update do |page|
           page.replace_html 'nomeprof', :text => 'Matricula não cadastrada'
           page.replace_html 'titulos', :text => ''
         end
      else

        #$professor_id = Professor.find_by_matricula($teacher).id
        $professor_id = $teacher
        $id_professor = $professor_id
        $professor = Professor.find($teacher).nome
        @professor = Professor.find(:all,:conditions => ['id = ? and desligado = 0', $teacher])
        @tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = 'PERMANENTE'")
        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = 'ANUAL'")
        #@tp5 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = '5 ANOS'")
        render :update do |page|
          page.replace_html 'nomeprof', :text => '- ' + ($professor)
          page.replace_html 'titulos', :partial => 'mostrar_pont_titulos'
        end
      end
    end
  end

  def busca_prof
    render :update do |page|
      page.replace_html 'titulos', :partial => 'mostrar_pont_titulos'
    end
    $professor_id = nil
    $teacher = nil
  end

  def guarda_valor1

    $id_titulo = params[:titulo_professor_titulo_id]
    $valor = Titulacao.find_by_id($id_titulo).valor

    render :update do |page|
      page.replace_html 'valor', :text => 'Pontuação do Título: ' + ($valor).to_s
      #page.replace_html 'titulos', :partial => 'totaliza_titulo'
    end


  end

  def guarda_valor

    $id_titulo = params[:titulo_professor_titulo_id]
    $valor = Titulacao.find_by_id($id_titulo).valor

    if $id_titulo.to_i == 8 or $id_titulo.to_i == 6
      render :update do |page|
        page.replace_html 'a_distancia', :text => ""
        page.replace_html 'a_distancia1', :text => ""
        page.replace_html 'valor', :text => 'Pontuação: ' + ($valor).to_s + ' ponto  por hora'
        page.replace_html 'qtde', :text => "<input id='titulo_professor_quantidade' type='text' value='0' size='10' name='titulo_professor[quantidade]'>"
      end
    else
      if $id_titulo.to_i == 1 || $id_titulo.to_i == 2 || $id_titulo.to_i == 3 || $id_titulo.to_i == 4 || $id_titulo.to_i == 5
        render :update do |page|
          page.replace_html 'a_distancia', :text => ""
          page.replace_html 'a_distancia1', :text => ""
          page.replace_html "qtde", :text => "1"
          page.replace_html 'valor', :text => 'Pontuação: ' + ($valor).to_s
        end
      else
        if $id_titulo.to_i == 7
          render :update do |page|
            page.replace_html 'a_distancia', :text => "1) Se CURSO À DISTÂNCIA desmarcar a caixa de seleção PRESENCIAL"
            page.replace_html 'a_distancia1', :text => "2)CURSOS À DISTÂNCIA: válidos somente para cursos com carga horario superior à 30 horas "
            page.replace_html 'tipo_titulo', :text => "<input id='titulo_professor_tipo_curso' type='checkbox' value='0' name='titulo_professor[tipo_curso]' checked='checked'> Presencial"
            page.replace_html 'valor', :text => '3) Pontualçao:' + ($valor).to_s + ' ponto por hora'
            page.replace_html 'qtde', :text => "<input id='titulo_professor_quantidade' type='text' value='0' size='10' name='titulo_professor[quantidade]'>"
            
          end
        end
      end
    end
  end


  def nome_professor

    $id_professor = params[:titulo_professor_titulo_id]
    $professor = Professor.find_by_id($id_professor).nome

    render :update do |page|
      page.replace_html 'nome', :text => 'Nome:: ' + ($professror)
      #page.replace_html 'titulos', :partial => 'totaliza_titulo'
    end

  end


 def titulos_busca
     $professor = Professor.find(params[:altera_professor_id]).nome
     @titulo_busca =  TituloProfessor.find(:all,:conditions =>['professor_id = ? and (ano_letivo = ? or titulo_id in (1,2,3,4,5))',params[:altera_professor_id],Time.current.strftime("%Y")])
      render :update do |page|
        page.replace_html 'nomeprof', :text => '- ' + ($professor)
        page.replace_html 'alteracao', :partial => 'alterar'
      end
 end


 def impressao
        @professor= Professor.find(:all,:conditions => ["id = ?  and desligado = 0",$teacher])
        @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", $teacher, 2009,$ano] )
        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = 'ANUAL'and ano_letivo ="+$ano.to_s)
       render :layout => "impressao"
end

def consulta_titulo_professor
     $teacher = params[:consulta][:professor_id]

      $ano = params[:ano_letivo]
        @professor= Professor.find(:all,:conditions => ["id = ? and desligado = 0",$teacher])

        @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", $teacher, 2009,$ano] )

        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = 'ANUAL'and ano_letivo ="+$ano)
           render :update do |page|

          page.replace_html 'titulos', :partial => 'mostrar_pont_titulos_1'
        end
end


 protected

  def load_titulacao
    @titulacaos = Titulacao.find(:all)
  end

  def load_professors
    @professors = Professor.find(:all, :conditions => ["desligado = 0"], :order => "matricula ASC")
  end

  def load_professors1
    @professors1 = Professor.find(:all, :conditions => ["desligado = 0"], :order => "nome ASC")
  end

  def load_professors_consulta
    @professors_consulta = Professor.find(:all, :conditions => ["desligado = 0"], :order => "nome ASC")
  end

def lista_professor
        $teacher = params[:professor_professor_id]
        @professor= Professor.find(:all,:conditions => ["id = ?",$teacher])
        @tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = 'PERMANENTE'")
        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = 'ANUAL'")
        render :update do |page|

          page.replace_html 'titulos', :partial => 'mostrar_pont_titulos'
        end
  end



  def professor_unidade
    if current_user.unidade_id == 53 or current_user.unidade_id == 52 then
      @professor_sede = Professor.all(:order => 'matricula')
    else
      @professor_sede = Professor.all(:conditions => ['sede_id = ' + current_user.unidade_id.to_s + ' or sede_id = 54'], :order => 'matricula')
    end
  end

  def load_consulta_ano
    @ano = TituloProfessor.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
 
  end

end