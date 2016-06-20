class UnidadesController < ApplicationController
  # GET /unidades
  # GET /unidades.xml
   before_filter :load_unidades
   before_filter :load_tipos

def load_tipos
      @tipos = Tipo.find(:all, :order => 'nome ASC')
end


  def load_unidades
      @unidades = Unidade.find(:all, :order => 'nome ASC')
      @professor= Professor.find(:all, :conditions => ['unidade_id=?', current_user.unidade_id])
  end

  def index
    @unidades = Unidade.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @unidades }
    end
  end

  # GET /unidades/1
  # GET /unidades/1.xml
  def show
    @unidade = Unidade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unidade }
    end
  end

  # GET /unidades/new
  # GET /unidades/new.xml
  def new
    @unidade = Unidade.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @unidade }
    end
  end

  # GET /unidades/1/edit
  def edit
    @unidade = Unidade.find(params[:id])
  end

  # POST /unidades
  # POST /unidades.xml
  def create
    @unidade = Unidade.new(params[:unidade])

    respond_to do |format|
      if @unidade.save
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@unidade) }
        format.xml  { render :xml => @unidade, :status => :created, :location => @unidade }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @unidade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /unidades/1
  # PUT /unidades/1.xml
  def update
    @unidade = Unidade.find(params[:id])

    respond_to do |format|
      if @unidade.update_attributes(params[:unidade])
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@unidade) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @unidade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /unidades/1
  # DELETE /unidades/1.xml
  def destroy
    @unidade = Unidade.find(params[:id])
    @unidade.destroy

    respond_to do |format|
      format.html { redirect_to(unidades_url) }
      format.xml  { head :ok }
    end
  end

 def consulta_unidade
   if params[:type_of].to_i == 1

   else if params[:type_of].to_i == 2
    t=0
            @unidades = Unidade.find(:all, :conditions => ["endereco like ?", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
           render :update do |page|
                page.replace_html 'unidades', :partial => "unidades"
              end
         else if params[:type_of].to_i == 3
              end
          end
  end
end

 def lista_unidade_nome
    @unidades = Unidade.find(:all, :conditions => ['id=?', params[:unidade_unidade_id]])
    render :partial => 'unidades'
  end

 def lista_tipo
   @unidades = Unidade.find(:all, :conditions => ['tipo_id=?', params[:unidade_tipo_id]])
   
   render :partial => 'unidades'
  end


end


