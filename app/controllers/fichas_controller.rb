class FichasController < ApplicationController
  # GET /relatorios
  # GET /relatorios.xml


 
  before_filter :load_professors
  before_filter :load_consulta_ano

  def index
    @relatorios = Relatorio.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @relatorios }
    end
  end

  # GET /relatorios/1
  # GET /relatorios/1.xml
  def show
    @relatorio = Relatorio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/new
  # GET /relatorios/new.xml
  def new
    @relatorio = Relatorio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/1/edit
  def edit
    @relatorio = Relatorio.find(params[:id])
  end

  # POST /relatorios
  # POST /relatorios.xml
  def create
    @relatorio = Relatorio.new(params[:relatorio])

    respond_to do |format|
      if @relatorio.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@relatorio) }
        format.xml  { render :xml => @relatorio, :status => :created, :location => @relatorio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /relatorios/1
  # PUT /relatorios/1.xml
  def update
    @relatorio = Relatorio.find(params[:id])

    respond_to do |format|
      if @relatorio.update_attributes(params[:relatorio])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@relatorio) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /relatorios/1
  # DELETE /relatorios/1.xml
  def destroy
    @relatorio = Relatorio.find(params[:id])
    @relatorio.destroy

    respond_to do |format|
      format.html { redirect_to(relatorios_url) }
      format.xml  { head :ok }
    end
  end


  def consultarelatorio
  end


def lista_relatorio_empresa
    $unidade = params[:relatorio_unidade_id]
   @relatorios = Relatorio.find(:all, :conditions => ['unidade_id=' + $unidade])
    render :partial => 'relatorios'
end

def lista_relatorio_obreiro
    $obreiro = params[:relatorio_obreiro_id]
    @relatorios = Relatorio.find(:all, :conditions => ['obreiro_id=?', $obreiro],:order => 'created_at DESC')
    render :partial => 'relatorios'
end


def lista_relatorio_data
     session[:data] = params[:relatorio_data]
     session[:type]= 3
    if (current_user.unidade_id==9999)
        @relatorios = Relatorio.find(:all, :conditions => ['data=?', session[:data]])
    else if (current_user.obreiro_id == nil)
            @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.id = ? AND data=?", current_user.unidade_id ,  session[:data]])
            else if (current_user.unidade_id ==  nil)
                   @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.obreiro_id = ? AND data=?", current_user.obreiro_id ,  session[:data]])
                end
            end
     end
    render :partial => 'relatorios'
end

def impressao
  
end

def consulta_ficha_pontuacao
     $teacher = params[:consulta][:professor_id]
      $ano = params[:ano_letivo]
        @professor= Professor.find(:all,:conditions => ["id = ? and desligado = 0",$teacher])
        @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', $teacher, $ano])
        @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", $teacher, 2009,$ano] )

        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = 'ANUAL'and ano_letivo ="+$ano)
           render :update do |page|

          page.replace_html 'titulos', :partial => 'mostrar_pontuacao'
        end
end


 protected


  def load_professors
    @professors = Professor.find(:all, :conditions => ["desligado = 0"], :order => "matricula ASC")
  end

  def load_consulta_ano
    @ano = TituloProfessor.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')

  end


end
