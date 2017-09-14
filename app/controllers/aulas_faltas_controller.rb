class AulasFaltasController < ApplicationController
  # GET /aulas_faltas
  # GET /aulas_faltas.xml
  before_filter :load_iniciais


  def index
         
        @date = params[:month] ? Date.parse(params[:month]) : Date.today

        @date.strftime("%m")


        @search = AulasFalta.search(params[:search])
       
        if !(params[:search].blank?)
            @aulas_faltas = @search.all
            @aulas_faltas_unidade = @search.first
        end
        session[:search]=params[:search]
          if !(params[:search].blank?)
              params[:search][:unidade_id_equals]
              @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+@date.strftime("%m")+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(params[:search][:unidade_id_equals]).to_s+" AND professor_id IS NOT NULL ) GROUP BY professor_id")
              @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+@date.strftime("%m")+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(params[:search][:unidade_id_equals]).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
           end
  end

   def index2

        @date = params[:month] ? Date.parse(params[:month]) : Date.today

        @search = AulasEventual.search(params[:search])
        if !(params[:search].blank?)
            @aulas_faltas = @search.all
            @aulas_faltas_unidade = @search.first
        end

  end

  # GET /aulas_faltas/1
  # GET /aulas_faltas/1.xml
  def show
    @aulas_falta = AulasFalta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aulas_falta }
    end
  end

  # GET /aulas_faltas/new
  # GET /aulas_faltas/new.xml
  def new
    @aulas_falta = AulasFalta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aulas_falta }
    end
  end

  # GET /aulas_faltas/1/edit
  def edit
    @aulas_falta = AulasFalta.find(params[:id])
  end

  # POST /aulas_faltas
  # POST /aulas_faltas.xml
  def create
    @aulas_falta = AulasFalta.new(params[:aulas_falta])
    @aulas_falta =  Time.now.year
    respond_to do |format|
      if @aulas_falta.save
        flash[:notice] = 'AulasFalta was successfully created.'
        format.html { redirect_to(@aulas_falta) }
        format.xml  { render :xml => @aulas_falta, :status => :created, :location => @aulas_falta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aulas_falta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aulas_faltas/1
  # PUT /aulas_faltas/1.xml
  def update
    @aulas_falta = AulasFalta.find(params[:id])

    respond_to do |format|
      if @aulas_falta.update_attributes(params[:aulas_falta])
        flash[:notice] = 'AulasFalta was successfully updated.'
        format.html { redirect_to(@aulas_falta) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aulas_falta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aulas_faltas/1
  # DELETE /aulas_faltas/1.xml
  def destroy
    @aulas_falta = AulasFalta.find(params[:id])
    @aulas_falta.destroy

    respond_to do |format|
      format.html { redirect_to(aulas_faltas_url) }
      format.xml  { head :ok }
    end
  end

  def data_falta
    session[:aulas_falta_data]=  params[:aulas_falta_data]

end


def nome_falta
        session[:aulas_falta_unidade_id]=params[:aulas_falta_unidade_id]
        @professores = Professor.find(:all, :conditions => ['unidade_id =? or unidade_id =? ', params[:aulas_falta_unidade_id], 54], :order => 'nome ASC')
        @funcionarios = Funcionario.find(:all, :conditions => ['unidade_id =? ', params[:aulas_falta_unidade_id]], :order => 'nome ASC')

        if (@professores.present?) or  (@funcionarios.present?)
           render :partial => 'selecao_falta'
        else
           render :partial => 'aviso'
        end
    end


def relatorios_faltas
    session[:mes_falta]=params[:mes]
    session[:unidade_id]=params[:aulas_falta][:unidade_id]
    if params[:mes] == '1'
        session[:mes] = 'JANEIRO'
    else if params[:mes] == '2'
            session[:mes] = 'FEVEREIRO'
         else if params[:mes] == '3'
                 session[:mes] = 'MARÇO'
              else if params[:mes] == '4'
                     session[:mes] = 'ABRIL'
                      else if params[:mes] == '5'
                             session[:mes] = 'MAIO'
                          else if params[:mes] == '6'
                                 session[:mes] = 'JUNHO'
                               else if params[:mes] == '7'
                                     session[:mes] = 'JULHO'
                                      else if params[:mes] == '8'
                                           session[:mes] = 'AGOSTO'
                                           else if params[:mes] == '9'
                                                 w=session[:mes] = 'SETEMBRO'
                                                   else if params[:mes] == '10'
                                                        session[:mes] = 'OUTUBRO'
                                                          else if params[:mes] == '11'
                                                                 session[:mes] = 'NOVEMBRO'
                                                                  else if params[:mes] == '12'
                                                                         session[:mes] = 'DEZEMBRO'
                                                                       end
                                                               end
                                                       end
                                                  end
                                          end
                                     end
                               end
                         end
                    end
               end
          end
    end

    @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND unidade_id=?", params[:mes], Time.now.year, params[:aulas_falta][:unidade_id]], :order => 'data ASC')
     @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
     @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
       render :update do |page|
          page.replace_html 'calendario', :partial => 'faltas'
       end
end

def impressao_faltas
     @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND unidade_id=?", session[:mes_falta], Time.now.year, session[:unidade_id]], :order => 'data ASC')
     @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
     @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
     render :layout => "impressao"
end

  def load_iniciais
         if current_user.has_role?('admin') or current_user.has_role?('SEDUC')
            @unidades_infantil = Unidade.find(:all,  :select => 'nome, id',:conditions =>  ["tipo_id = 2 OR tipo_id = 5 OR tipo_id = 8"], :order => 'nome ASC')
            @professores_eventual_infantil2 = Eventual.find(:all, :select => 'professors.id, professors.nome, eventuals.id', :joins => :professor,  :conditions=> [ 'eventuals.ano_letivo =?',Time.now.year ] ,:order => 'professors.nome ASC')
         else
            @unidades_infantil = Unidade.find(:all,  :select => 'nome, id', :conditions =>  ["id=?", current_user.unidade_id], :order => 'nome ASC')
            @professores_eventual_infantil2 = Eventual.find(:all, :select => 'professors.id, professors.nome, eventuals.id', :joins => :professor,  :conditions=> [ 'eventuals.ano_letivo =? and eventuals.unidade_id=?',Time.now.year, current_user.unidade_id ] ,:order => 'professors.nome ASC')
            t=0
         end
       @professores_eventual_infantil = Eventual.find(:all, :select => 'professors.id, professors.nome, eventuals.id', :joins => :professor,  :conditions=> [ 'eventuals.ano_letivo =?',Time.now.year ] ,:order => 'professors.nome ASC')

    end



end
