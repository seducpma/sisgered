class AulasEventualsController < ApplicationController
    # GET /aulas_eventuals
    # GET /aulas_eventuals.xml
    before_filter :load_iniciais


    def index

        @date = params[:month] ? Date.parse(params[:month]) : Date.today
        
        @search = AulasEventual.search(params[:search])
        if !(params[:search].blank?)
            @aulas_eventual = @search.all
            @aulas_eventual_unidade = @search.first
        end
    end


   
   def index2

        @date = params[:month] ? Date.parse(params[:month]) : Date.today

        @search = AulasEventual.search(params[:search])
        if !(params[:search].blank?)
            @aulas_eventual = @search.all
            @aulas_eventual_unidade = @search.first
        end
      
  end

  def destroy
        @aulas_eventual = AulasEventual.find(params[:id])
        @aulas_eventual.destroy

        respond_to do |format|
            format.html { redirect_to(aulas_eventuals_url) }
            format.xml  { head :ok }
        end
    end

   def show

        @aulas_eventual = AulasEventual.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @aulas_eventual }
        end
    end

    # GET /aulas_eventuals/new
    # GET /aulas_eventuals/new.xml
    def new

        @aulas_eventual = AulasEventual.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @aulas_eventual }
        end
    end

    # GET /aulas_eventuals/1/edit
    def edit
        @aulas_eventual = AulasEventual.find(params[:id])
    end

    # POST /aulas_eventuals
    # POST /aulas_eventuals.xml
    def create
        @aulas_eventual = AulasEventual.new(params[:aulas_eventual])
        @aulas_eventual.ano_letivo = Time.now.year

        respond_to do |format|
            if @aulas_eventual.save
                flash[:notice] = 'AulasEventual was successfully created.'
                format.html { redirect_to(@aulas_eventual) }
                format.xml  { render :xml => @aulas_eventual, :status => :created, :location => @aulas_eventual }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @aulas_eventual.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /aulas_eventuals/1
    # PUT /aulas_eventuals/1.xml
    def update
        @aulas_eventual = AulasEventual.find(params[:id])

        respond_to do |format|
            if @aulas_eventual.update_attributes(params[:aulas_eventual])
                flash[:notice] = 'AulasEventual was successfully updated.'
                format.html { redirect_to(@aulas_eventual) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @aulas_eventual.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /aulas_eventuals/1
    # DELETE /aulas_eventuals/1.xml


def data_eventual
    session[:aulas_eventual_data]=  params[:aulas_eventual_data]
end
    def nome_prof_eventual
        session[:aulas_eventual_unidade_id]=params[:aulas_eventual_unidade_id]
        @professores = Eventual.find_by_sql("SELECT eventuals.id, professors.nome FROM eventuals INNER JOIN  professors  ON  professors.id = eventuals.professor_id WHERE eventuals.id NOT IN (SELECT aulas_eventuals.eventual_id FROM aulas_eventuals WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"' AND aulas_eventuals.unidade_id = "+session[:aulas_eventual_unidade_id]+" )")
        render :partial => 'selecao_professor'
    end


    def observacao_prof_eventual
        @professor = Eventual.find(:all, :conditions => ['id = ?',  params[:aulas_eventual_eventual_id]] )
        render :partial => 'observacaos'

    end

    def load_iniciais
        @unidades_infantil = Unidade.find(:all, :conditions =>  ["tipo_id = 2 OR tipo_id = 5 OR tipo_id = 8"], :order => 'nome ASC')
        @professores_eventual_infantil = Eventual.find(:all, :select => 'professors.id, professors.nome, eventuals.id', :joins => :professor,  :conditions=> [ 'eventuals.ano_letivo =?',Time.now.year ] ,:order => 'professors.nome ASC')

    end


end
