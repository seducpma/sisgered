class ClassesController < ApplicationController




  # GET /classes
  # GET /classes.xml
  before_filter :load_professors
  before_filter :load_classes
  before_filter :load_alunos
  


  def index
    @classes = Classe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classes }
    end
  end

  # GET /classes/1
  # GET /classes/1.xml
  def show
    @classe = Classe.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @class }
    end
  end

  # GET /classes/new
  # GET /classes/new.xml
  def new
    @classe = Classe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @classe }
    end
  end

  # GET /classes/1/edit
  def edit
    @classe = Classe.find(params[:id])
#   @livro = Livro.find(params[:id])
    @alunos_selecionados = @classe.alunos
    @alunos = @alunos - @alunos_selecionados

  
#    @assuntos_selecionados = @livro.assuntos
#    @assuntos = @assuntos - @assuntos_selecionados




  end

  # POST /classes
  # POST /classes.xml
  def create
    @classe = Classe.new(params[:classe])
    respond_to do |format|
      if @classe.save
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classe) }
        format.xml  { render :xml => @classe, :status => :created, :location => @classs }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @classe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /classes/1
  # PUT /classes/1.xml
  def update
    @classe = Classe.find(params[:id])


    respond_to do |format|
      if @classe.update_attributes(params[:classe])

        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classe) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @classe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /classes/1
  # DELETE /classes/1.xml
  def destroy
    @classe = Classe.find(params[:id])
    @classe.destroy

    respond_to do |format|
      format.html { redirect_to(home_path) }
      format.xml  { head :ok }
    end
  end


def destroy_classe_aluno
  aluno_id=params[:id]
  classe_id= session[:classe_id]

  @classe =Classe.find(session[:classe_id])
  results = ActiveRecord::Base.connection.execute("DELETE FROM `alunos_classes` WHERE `aluno_id`="+(aluno_id).to_s+ " and classe_id="+(classe_id).to_s)
  t=0
end
 #aluno_id=params[:id]
# classe_id= session[:classe_id]

 # @classealuno = AlunosClasse.find_by_sql("SELECT * FROM `alunos_classes`WHERE `aluno_id`="+(aluno_id).to_s + " and classe_id="+(classe_id).to_s)
 
  #@classealuno = AlunosClasse.find_by_sql("DELETE FROM `alunos_classes` WHERE `aluno_id`="+(aluno_id).to_s + " and classe_id="+(classe_id).to_s)

 #    Post.delete_all("aluno_id="+(aluno_id).to_s + " and classe_id="+(classe_id).to_s)

  # @classealuno.destroy




   #respond_to do |format|
    #  format.html { redirect_to(home_path) }
     # format.xml  { head :ok }
   # end
 # end




#def destroy_classe_aluno
#  aluno_id=params[:id]
#  classe_id= session[:classe_id]
#  @classealuno = AlunosClasse.find_by_sql("SELECT * FROM `alunos_classes`WHERE `aluno_id`="+(aluno_id).to_s + " and classe_id="+(classe_id).to_s)
#t=0
#  if @classealuno.nil? flash[:error] = "object is not not found"
#      else if @classealuno.destroy flash[:notice] = 'blah'
#            respond_to do |format|
#               format.html { redirect_to home_path }
#               format.json { head :no_content }
#               format.js end
#           else flash[:error] = 'There was a problem fetching the record'
#              redirect_to home_path
#           end
#     end
# end




def destroy_classe_professor
  professor_id=params[:id]
  classe_id= session[:classe_id]
  @classe =Classe.find(session[:classe_id])
  results = ActiveRecord::Base.connection.execute("DELETE FROM `classes_professors` WHERE `professor_id`="+(professor_id).to_s + " and classe_id="+(classe_id).to_s)
end





  def seleciona_montar_classe
    @classe1 = Classe.find(:all, :conditions => ['id= ?',params[:classe_id]])
  
    render :partial => 'dados_classe'
  end




  def load_professors
    if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @professors = Professor.find(:all, :order => 'nome ASC')
    else
        @professors = Professor.find(:all, :conditions => ['unidade_id = ? or unidade_id = 54', current_user.unidade_id  ],:order => 'matricula ASC')
    end
  end


def consulta_classe_aluno
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end

def editar_classe_aluno
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe_editar'
       end
end


 def destroy_professor
   t=(params[:id])
    @atribuicao = Atribuicao.find(params[:id])

    @atribuicao.destroy

    respond_to do |format|
      format.html { redirect_to(home_path) }
      format.xml  { head :ok }
    end
  end

def impressao_classe
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe]])
@transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe]])
      render :layout => "impressao"
end

 def load_classes
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classe = Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
    end
 end


  def load_alunos
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @alunos = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `id`not in (SELECT alunos_classes.aluno_id FROM classes INNER JOIN alunos_classes ON classes.id = alunos_classes.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+") ORDER BY aluno_nome ASC")
    else
        unidade=  current_user.unidade_id
        @alunos = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `unidade_id`= "+unidade.to_s+" AND`id`not in (SELECT alunos_classes.aluno_id FROM classes INNER JOIN alunos_classes ON classes.id = alunos_classes.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")ORDER BY aluno_nome ASC")
      
       #@alunos = Aluno.find(:all, :conditions => ['unidade_id = ? AND id  not in ', current_user.unidade_id ], :order => 'aluno_nome ASC')
    end

 end
end
