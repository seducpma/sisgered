class ConteudosController < ApplicationController
  # GET /conteudos
  # GET /conteudos.xml
     before_filter :load_dados_iniciais


   def load_dados_iniciais

       if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('Supervisão')
          @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
              else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil') or    current_user.has_role?('pedagogo')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                   else if current_user.has_role?('professor_fundamental')
                         @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
                          else if  current_user.has_role?('direcao_fundamental')   or    current_user.has_role?('secretaria_fundamental') or    current_user.has_role?('pedagogo')
                               @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                              end

                          end
                    end
              end
       end
  end

def classe
    w=session[:professor_id]=params[:conteudo_professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
    if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
       if @atribuicao.count > 1
           render :partial => 'disciplina'
       else
           session[:cont_atribuicao_id]=@atribuicao[0].id
           session[:cont_classe_id]= @atribuicao[0].classe_id
           render :partial => 'dados_classe'
       end
    end
  end


def disciplina
 session[:cont_disciplina_id] =  params[:disciplina_id]
 @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and disciplina_id =?", session[:professor_id], Time.now.year, params[:disciplina_id] ])
 session[:cont_classe_id]= @atribuicao[0].classe_id
 session[:cont_atribuicao_id]=@atribuicao[0].id

        render :partial => 'dados_classe'
end

  def index
    @conteudos = Conteudo.all

                    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conteudos }
    end
  end

  # GET /conteudos/1
  # GET /conteudos/1.xml
  def show
    @conteudo = Conteudo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end

  # GET /conteudos/new
  # GET /conteudos/new.xml
  def new
    @conteudo = Conteudo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conteudo }
    end
  end

  # GET /conteudos/1/edit
  def edit
    @conteudo = Conteudo.find(params[:id])
  end

  # POST /conteudos
  # POST /conteudos.xml
  def create
    @conteudo = Conteudo.new(params[:conteudo])
    @conteudo.disciplina_id= session[:cont_disciplina_id]
    @conteudo.classe_id= session[:cont_classe_id]
    @conteudo.atribuicao_id= session[:cont_atribuicao_id]
    respond_to do |format|
      if @conteudo.save
        flash[:notice] = 'Conteudo was successfully created.'
        format.html { redirect_to(@conteudo) }
        format.xml  { render :xml => @conteudo, :status => :created, :location => @conteudo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conteudo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conteudos/1
  # PUT /conteudos/1.xml
  def update
    @conteudo = Conteudo.find(params[:id])

    respond_to do |format|
      if @conteudo.update_attributes(params[:conteudo])
        flash[:notice] = 'Conteudo was successfully updated.'
        format.html { redirect_to(@conteudo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conteudo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conteudos/1
  # DELETE /conteudos/1.xml
  def destroy
    @conteudo = Conteudo.find(params[:id])
    @conteudo.destroy

    respond_to do |format|
      format.html { redirect_to(conteudos_url) }
      format.xml  { head :ok }
    end
  end
end
