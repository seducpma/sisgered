class EventualsController < ApplicationController

    before_filter :load_iniciais


  # GET /eventuals
  # GET /eventuals.xml
  def index
    @eventuals = Eventual.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @eventuals }
    end
  end

  # GET /eventuals/1
  # GET /eventuals/1.xml
  def show
    @eventual = Eventual.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @eventual }
    end
  end

  # GET /eventuals/new
  # GET /eventuals/new.xml
  def new
    @eventual = Eventual.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @eventual }
    end
  end

  # GET /eventuals/1/edit
  def edit
    @eventual = Eventual.find(params[:id])
  end

  # POST /eventuals
  # POST /eventuals.xml
  def create
    @eventual = Eventual.new(params[:eventual])
    @eventual.ano_letivo = Time.now.year
    respond_to do |format|
      if @eventual.save
        flash[:notice] = 'Eventual was successfully created.'
        format.html { redirect_to(@eventual) }
        format.xml  { render :xml => @eventual, :status => :created, :location => @eventual }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @eventual.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /eventuals/1
  # PUT /eventuals/1.xml
  def update
    @eventual = Eventual.find(params[:id])

    respond_to do |format|
      if @eventual.update_attributes(params[:eventual])
        flash[:notice] = 'Eventual was successfully updated.'
        format.html { redirect_to(@eventual) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @eventual.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /eventuals/1
  # DELETE /eventuals/1.xml
  def destroy
    @eventual = Eventual.find(params[:id])
    @eventual.destroy

    respond_to do |format|
      format.html { redirect_to(eventuals_url) }
      format.xml  { head :ok }
    end
  end

  def consultas
      @professores_eventual = Professor.find_by_sql("SELECT id, nome FROM `professors` WHERE `id` in (SELECT professor_id FROM eventuals WHERE ano_letivo = "+(Time.now.year).to_s+")ORDER BY nome ASC")
  end


  def lista_professor
      w=params[:eventual_professor_id]

     @professors = Eventual.find(:all, :conditions => ['professor_id= ?', params[:eventual_professor_id]])

    render :partial => 'professores'
  end

    def load_iniciais
        @unidades_infantil = Unidade.find(:all, :conditions =>  ["tipo_id = 2 OR tipo_id = 5 OR tipo_id = 8"], :order => 'nome ASC')
        @eventuals = Eventual.find(:all,:select => "id", :conditions => ['ano_letivo=?', Time.now.year])
        @professores= Professor.find_by_sql("SELECT id, nome FROM professors WHERE `id` NOT IN ( SELECT professor_id FROM eventuals )" )

    end

end
