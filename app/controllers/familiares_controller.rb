class FamiliaresController < ApplicationController
  # GET /familiares
  # GET /familiares.xml
    before_filter :load_funcionarios
    before_filter :load_unidades

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
     if (current_user.unidade_id==9999)
       @familiares = Familiare.find(:all, :order => 'nome ASC')
     else
       @familiares = Familiare.find(:all, :conditions => ["funcionario_id = ?", current_user.unidade_id], :order => 'nome ASC')
     end
       respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :action => "new", :controller => :funcionarios }

    end
  end

  # GET /familiares/1
  # GET /familiares/1.xml
  def show
    @familiare = Familiare.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @familiare }
    end
  end

  # GET /familiares/new
  # GET /familiares/new.xml
  def new
    @familiare = Familiare.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @familiare }
    end
  end

  # GET /familiares/1/edit
  def edit
    @familiare = Familiare.find(params[:id])
  end

  # POST /familiares
  # POST /familiares.xml
  def create
    @familiare = Familiare.new(params[:familiare])

    respond_to do |format|
      if @familiare.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@familiare) }
        format.xml  { render :xml => @familiare, :status => :created, :location => @familiare }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @familiare.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /familiares/1
  # PUT /familiares/1.xml
  def update
    @familiare = Familiare.find(params[:id])

    respond_to do |format|
      if @familiare.update_attributes(params[:familiare])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@familiare) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @familiare.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /familiares/1
  # DELETE /familiares/1.xml
  def destroy
    @familiare = Familiare.find(params[:id])
    @familiare.destroy

    respond_to do |format|
      format.html { redirect_to(familiares_url) }
      format.xml  { head :ok }
    end
  end

   # def destroy
   # @professor = Professor.find(params[:id])
   # $prof_id = params[:id]
   # @titulo_professor = TituloProfessor.find(:all, :conditions => ['professor_id = ' + $prof_id])
   # @acum_professor = AcumTrab.find(:all, :conditions => ['professor_id = ' + $prof_id])
   # @trabalhado_professor = Trabalhado.find(:all, :conditions => ['professor_id = ' + $prof_id])
   # for titu_prof in @titulo_professor
   #   titu_prof.destroy
   # end
    #for trab_prof in @trabalhado_professor
    #  trab_prof.destroy
    #end
    #for acum_prof in @acum_professor
    #  acum_prof.destroy
    #end


  def consultafamiliar
   unless params[:search].present?
     if params[:type_of].to_i == 3
       if (current_user.unidade_id==9999)
          @familiares = Familiare.paginate(:all, :page => params[:page], :per_page => 50, :order => 'nome ASC')
       else if (current_user.obreiro_id == nil)
            @familiares = Familiare.find(:all,:include => [:funcionario=>[:unidade]], :conditions => ["funcionarios.unidade_id = ?", current_user.unidade_id])
            else if (current_user.unidade_id ==  nil)
                    @familiares =     Familiare.find(:all,:include => [:funcionario=>[:unidade]], :conditions => ["unidades.obreiro_id = ?", current_user.obreiro_id])
                    
                  end
             end
        end
        render :update do |page|
         page.replace_html 'familiares', :partial => "familiares"
       end
     end
   else
      if params[:type_of].to_i == 1
           if (current_user.unidade_id==9999)
               @familiares = Familiare.paginate( :all,:page => params[:page], :per_page => 50, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
           else if (current_user.obreiro_id == nil)
                @familiares = Familiare.find( :all,:include => [:funcionario=>[:unidade]], :conditions => ["familiares.nome like ? and funcionarios.unidade_id = ?", "%" + params[:search].to_s + "%",  current_user.unidade_id])
                else if (current_user.unidade_id ==  nil)
                        @familiares = Familiare.find( :all,:include => [:funcionario=>[:unidade]], :conditions => ["familiares.nome like ? and unidades.obreiro_id = ?", "%" + params[:search].to_s + "%",  current_user.obreiro_id])
                      end
                 end
          end
            render :update do |page|
            page.replace_html 'familiares', :partial => "familiares"
          end
              else if params[:type_of].to_i == 2
               render :update do |page|
                 page.replace_html 'familiares', :partial => "familiares"
              end
            end
      end
   end
end

  def lista_familiares_nome
    $funcionario = params[:funcionario_funcionario_id]
    @familiares = Familiare.find(:all, :conditions => ['funcionario_id=' + $funcionario])
    render :partial => 'familiares'
  end

  def lista_unidade_nome
    $unidade = params[:unidade_unidade_id]
    @familiares =     Familiare.find(:all,:include => [:funcionario=>[:unidade]], :conditions => ["funcionarios.unidade_id = ?", $unidade])
    render :partial => 'familiares'
  end


end
