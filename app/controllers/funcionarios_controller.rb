class FuncionariosController < ApplicationController
  # GET /funcionarios
  # GET /funcionarios.xml

    before_filter :load_unidades
    before_filter :load_funcionarios

 def load_funcionarios
    if (current_user.unidade_id==9999)
      @funcionarios = Funcionario.find(:all, :order => 'nome ASC')
     else if (current_user.obreiro_id == nil)
            @funcionarios = Funcionario.find(:all, :include => [:unidade], :conditions => ["unidade_id = ?", current_user.unidade_id], :order => 'nome ASC')
            else if (current_user.unidade_id ==  nil)
                  @funcionarios = Funcionario.find(:all, :include => [:unidade], :conditions => ["unidades.obreiro_id = ?", current_user.obreiro_id])
                  end
             end

     end
  end
  
 def load_unidades
      if (current_user.unidade_id==9999)
          @unidades = Unidade.find(:all, :order => 'nome ASC')
       else if (current_user.obreiro_id == nil)
            @unidades = Unidade.find(:all,:conditions => ["id = ?", current_user.unidade_id], :order => 'nome ASC')
            else if (current_user.unidade_id ==  nil)
                  @unidades = Unidade.find(:all,:conditions => ["obreiro_id = ?", current_user.obreiro_id], :order => 'nome ASC')
                  end
             end
       end
  end


  def index
    @funcionarios = Funcionario.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @funcionarios }
    end
  end

  # GET /funcionarios/1
  # GET /funcionarios/1.xml
  def show
    @funcionario = Funcionario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @funcionario }
    end
  end

  # GET /funcionarios/new
  # GET /funcionarios/new.xml
  def new
    @funcionario = Funcionario.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @funcionario }
    end
  end

  # GET /funcionarios/1/edit
  def edit
    @funcionario = Funcionario.find(params[:id])
  end

  # POST /funcionarios
  # POST /funcionarios.xml
  def create
    @funcionario = Funcionario.new(params[:funcionario])

    respond_to do |format|
      if @funcionario.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@funcionario) }
        format.xml  { render :xml => @funcionario, :status => :created, :location => @funcionario }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @funcionario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /funcionarios/1
  # PUT /funcionarios/1.xml
  def update
    @funcionario = Funcionario.find(params[:id])

    respond_to do |format|
      if @funcionario.update_attributes(params[:funcionario])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@funcionario) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @funcionario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /funcionarios/1
  # DELETE /funcionarios/1.xml
  def destroy
    @funcionario = Funcionario.find(params[:id])
    @funcionario.destroy

    respond_to do |format|
      format.html { redirect_to(funcionarios_url) }
      format.xml  { head :ok }
    end
  end

  def create_familiares
      @familiar = Familiare.new(params[:familiare])
      $teste=@familiar.nome
      $teste2=@familiar.parentesco
      if @familiar.save
        @familiares = Familiare.all(:conditions => ["funcionario_id is null"])
        session[:familiare_id] = @familiar.id
         render :update do |page|
            page.replace_html 'lista', :partial => "lista_familiares"
        end
      end
    end

 
  def consulta_nome
    render 'consulta_nome'
  end

  def consultafuncionario
   unless params[:search].present?
     if params[:type_of].to_i == 4
      if (current_user.unidade_id==9999)
          @funcionarios = Funcionario.find(:all, :order => 'nome ASC')
      else if (current_user.obreiro_id == nil)
            @funcionarios = Funcionario.find(:all, :include => [:unidade], :conditions => ["unidade_id = ?", current_user.unidade_id], :order => 'nome ASC')
            else if (current_user.unidade_id ==  nil)
                  @funcionarios = Funcionario.find(:all, :include => [:unidade], :conditions => ["unidades.obreiro_id = ?", current_user.obreiro_id])
                  end
             end
      end
       render :update do |page|
         page.replace_html 'funcionarios', :partial => "funcionarios"
       end
     end
   else
      if params[:type_of].to_i == 1
          @contador = Funcionario.all(:conditions => ["nome like ?", "%" + params[:search].to_s + "%"]).count
          @funcionarios = Funcionario.paginate( :all,:page => params[:page], :per_page => 50, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
          render :update do |page|
            page.replace_html 'funcionarios', :partial => "funcionarios"
          end
          else if params[:type_of].to_i == 2
            render :update do |page|
              page.replace_html 'funcionarios', :partial => "funcionarios"
            end
              else if params[:type_of].to_i == 3
               render :update do |page|
                 page.replace_html 'funcionarios', :partial => "funcionarios"
              end
            end
          end
      end
   end
end

  def lista_funcionario_nome
    $funcionario = params[:funcionario_funcionario_id]
    @funcionarios = Funcionario.find(:all, :conditions => ['id=' + $funcionario])
    render :partial => 'funcionarios'
  end
  
  def lista_unidade_nome
    $unidade = params[:unidade_unidade_id]
    @funcionarios = Funcionario.find(:all, :conditions => ['unidade_id=' + $unidade])
    render :partial => 'funcionarios'
  end

 def data_demissao
    render  :partial => 'datademissao'
 end
end


