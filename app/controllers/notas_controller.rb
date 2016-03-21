class NotasController < ApplicationController
  # GET /notas
  # GET /notas.xml
before_filter :load_classes
before_filter :load_professores



  def index
    @notas = Nota.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notas }
    end
  end

  # GET /notas/1
  # GET /notas/1.xml
  def show
    @nota = Nota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/new
  # GET /notas/new.xml
  def new
    @nota = Nota.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/1/edit
  def edit
    @nota = Nota.find(params[:id])
  end

  # POST /notas
  # POST /notas.xml
  def create
    @nota = Nota.new(params[:nota])

    respond_to do |format|
      if @nota.save
        flash[:notice] = 'Nota was successfully created.'
        format.html { redirect_to(@nota) }
        format.xml  { render :xml => @nota, :status => :created, :location => @nota }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notas/1
  # PUT /notas/1.xml
  def update
    @nota = Nota.find(params[:id])

    respond_to do |format|
      if @nota.update_attributes(params[:nota])
        flash[:notice] = 'Nota was successfully updated.'
        format.html { redirect_to(@nota) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nota.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notas/1
  # DELETE /notas/1.xml
  def destroy
    @nota = Nota.find(params[:id])
    @nota.destroy

    respond_to do |format|
      format.html { redirect_to(home_url) }
      format.xml  { head :ok }
    end
  end

def consulta_nota_aluno
       @classe = Classe.find(:all,:conditions =>['id = ? and professor_id =?', params[:classe][:id], current_user.id])
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end

def consulta_classe_nota
  t=params[:classe][:id]
  t1= params[:professor][:id]

       @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ?', params[:classe][:id], params[:professor][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =?', params[:classe][:id], params[:professor][:id]])

       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end

def create_notas_aluno
   t=params[:notas_aluno]
    @notas_aluno = Nota.new(params[:notas_aluno])
      t1=params[:notas_aluno]

      if @notas_aluno.save
        render :update do |page|
          #page.replace_html 'dados', :partial => "observacoes"
          page.replace_html 'edit'
        end
       end

end



 def load_classes
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classe = Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
    end
 end
def load_professores
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @professor = Professor.find(:all, :order => 'nome ASC')
    else
        #@classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
         @professor = Atribuicao.find(:all, :joins=>  :professor, :conditions => ['ano_letivo = ? and (professors.unidade_id = ? )', 2016,  current_user.unidade_id ], :order => 'professors.nome ASC')
         #@professor_com_ficha = Ficha.paginate(:all,:joins => :professor,:conditions => ['ano_letivo = ? and (professors.unidade_id = ? or professors.unidade_id = 54)  and professors.matricula = ?', params[:year], current_user.regiao_id,params[:search]])
    end
 end

end
