class TransferenciasController < ApplicationController
  # GET /transferencias
  # GET /transferencias.xml

    before_filter :load_dados_iniciais

  
  def index
    @transferencias = Transferencia.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transferencias }
    end
  end

  # GET /transferencias/1
  # GET /transferencias/1.xml
  def show
    @transferencia = Transferencia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transferencia }
    end
  end

  # GET /transferencias/new
  # GET /transferencias/new.xml
  def new
    @transferencia = Transferencia.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transferencia }
    end
  end

  # GET /transferencias/1/edit
  def edit
    @transferencia = Transferencia.find(params[:id])
  end

  # POST /transferencias
  # POST /transferencias.xml
  def create
    @transferencia = Transferencia.new(params[:transferencia])

    respond_to do |format|
      if @transferencia.save
        flash[:notice] = 'Transferencia was successfully created.'
        format.html { redirect_to(@transferencia) }
        format.xml  { render :xml => @transferencia, :status => :created, :location => @transferencia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transferencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transferencias/1
  # PUT /transferencias/1.xml
  def update
    @transferencia = Transferencia.find(params[:id])

    respond_to do |format|
      if @transferencia.update_attributes(params[:transferencia])
        flash[:notice] = 'Transferencia was successfully updated.'
        format.html { redirect_to(@transferencia) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transferencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transferencias/1
  # DELETE /transferencias/1.xml
  def destroy
    @transferencia = Transferencia.find(params[:id])
    @transferencia.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end


  def consulta_transferencia

  end

def consulta_transferencia_classe
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @transferencia = Transferencia.find(:all, :conditions => ['unidade_id =?',current_user.unidade_id] )
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'transferencias_classe'
       end
end


  def unidade_transferencia
   unidade_id = Unidade.find_by_nome(params[:transferencia_de])
   @alunos = Aluno.find(:all, :conditions =>['unidade_id =?',  unidade_id], :order => 'aluno_nome')
   @unidade_para = Unidade.find(:all, :conditions => ['id =?', current_user.unidade_id], :order => 'nome ASC')
   @classes = Classe.find(:all, :conditions =>['unidade_id =?',  current_user.unidade_id], :order => 'classe_classe')
   render :partial => 'selecao_alunos'






  end

  def load_dados_iniciais
       @unidade_de = Unidade.find(:all, :order => 'nome ASC')
       @unidade_para = Unidade.find(:all, :order => 'nome ASC')
       @alunos = Aluno.find(:all, :order => 'aluno_nome')
       @classes = Classe.find(:all, :conditions =>['unidade_id=?', current_user.unidade_id],:order => 'classe_classe')
       unidade=  current_user.unidade_id
       @alunos1 = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `unidade_id`= "+unidade.to_s+" AND`id`not in (SELECT alunos_classes.aluno_id FROM classes INNER JOIN alunos_classes ON classes.id = alunos_classes.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")ORDER BY aluno_nome ASC")
       if current_user.unidade_id == 53 or current_user.unidade_id == 52
             @classe = Classe.find(:all, :order => 'classe_classe ASC')
       else
             @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
       end
       @alunos1 = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `unidade_id`= "+unidade.to_s+" AND`id`not in (SELECT alunos_classes.aluno_id FROM classes INNER JOIN alunos_classes ON classes.id = alunos_classes.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")ORDER BY aluno_nome ASC")
       @alunos2 = Aluno.find(:all, :conditions =>['unidade_id=?', current_user.unidade_id],:order => 'aluno_nome')
  end
end
