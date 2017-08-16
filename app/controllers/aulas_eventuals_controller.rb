class AulasEventualsController < ApplicationController
  # GET /aulas_eventuals
  # GET /aulas_eventuals.xml
  before_filter :load_iniciais


 def index
     t=0
   @date = params[:month] ? Date.parse(params[:month]) : Date.today
   @search = AulasEventual.search(params[:search])

   if !(params[:search].blank?)
    @aulas_eventual = @search.all
    @aulas_eventual_unidade = @search.first
   end
  end

#  def index
#    @date = params[:month] ? Date.parse(params[:month]) : Date.today
#    @aulas_eventuals = AulasEventual.all
 #   respond_to do |format|
 #     format.html # index.html.erb
 #     format.xml  { render :xml => @aulas_eventuals }
 #   end
 # end

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
  def destroy
    @aulas_eventual = AulasEventual.find(params[:id])
    @aulas_eventual.destroy

    respond_to do |format|
      format.html { redirect_to(aulas_eventuals_url) }
      format.xml  { head :ok }
    end
  end

 def load_iniciais
    @unidades_infantil = Unidade.find(:all, :conditions =>  ["tipo_id = 2 OR tipo_id = 5 OR tipo_id = 8"], :order => 'nome ASC')
  end


end
