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

  def editar_transferencia
   
end

  def editar_transferencia_aluno

       session[:aluno] = params[:aluno][:id]
       @transferencia = Transferencia.find(:all,:conditions =>['aluno_id = ?', session[:aluno]])
       render :update do |page|
          page.replace_html 'transferencia', :partial => 'dados_transferencia'
       end
end

  # POST /transferencias
  # POST /transferencias.xml
  def create
    @transferencia = Transferencia.new(params[:transferencia])
     if session[:nao_fazer]== 0
        @transferencia.para = (current_user.unidade.nome).capitalize
     end
       @classe_ant= Classe.find(:all, :joins => "INNER JOIN  alunos_classes  ON  classes.id=alunos_classes.classe_id  INNER JOIN alunos ON alunos.id=alunos_classes.aluno_id", :conditions =>['aluno_id = ?',@transferencia.aluno_id])
        for classe_ant in @classe_ant
           session[:classe_ant]= classe_ant.id
        end
        @atribuicaos_ant = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe_ant]])
        @atribuicao = Atribuicao.find(:all,:conditions =>['classe_id = ?', @transferencia.classe_id])
        @notas_ant = Nota.find(:all, :conditions => ['aluno_id = ? AND unidade_id =? AND ano_letivo=?', @transferencia.aluno_id, session[:unidade_ant_id], Time.now.year])
          respond_to do |format|
            if @transferencia.save
             if (!@transferencia.classe_id.nil?) then

              if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
                 for atri in @atribuicao
                   @nota = Nota.new(params[:nota])
                   @nota.aluno_id = @transferencia.aluno_id
                   @nota.atribuicao_id= atri.id
                   @nota.professor_id= atri.professor_id
                   @nota.disciplina_id = atri.disciplina_id
                   @nota.unidade_id=  @transferencia.unidade_id
                   @nota.disciplina_id= atri.disciplina_id
                   @nota.ano_letivo =  Time.now.year
                    for notas_ant in @notas_ant
                      if atri.disciplina_id == notas_ant.disciplina_id
                        if !notas_ant.nota1.nil?
                           @nota.nota1 = notas_ant.nota1
                        else
                          @nota.nota1 = nil
                        end
                        if !notas_ant.nota2.nil?
                           @nota.faltas2 = notas_ant.falt2
                        else
                           @nota.faltas2 = nil
                        end
                        if !notas_ant.nota3.nil?
                           @nota.nota3 = notas_ant.nota3
                        else
                           @nota.nota3 = nil
                        end
                        if !notas_ant.nota4.nil?
                           @nota.faltas4 = notas_ant.falt4
                       else
                           @nota.faltas4 = nil
                       end
                     end
                   end
                 @nota.nota5 = nil
                 @nota.faltas5= nil
                 if @nota.save
                    flash[:notice] = 'DADOS SALVOS COM SUCESSO!'
                 end
             end
              session[:nao_fazer]= 0
            end
            @notas= Nota.find(:all, :conditions=>["aluno_id = ?", @transferencia.aluno_id ])
           else
             t=0
           end
             flash[:notice] = 'TRANSFERẼNCIA REALIZADA COM SUCESSO'
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
        flash[:notice] = 'TRANSFERẼNCIA REALIZADA COM SUCESSO'
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


       @transferencia1 = Transferencia.find(:all, :conditions => ['unidade_id =? and classe_id=?',current_user.unidade_id,params[:classe][:id]] )
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
       @transferencia = Transferencia.find(:all, :joins => [:aluno], :conditions => ['alunos.unidade_anterior =? and transferencias.classe_id=?',current_user.unidade_id,params[:classe][:id]] )
       #@notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'notas.bimestre ASC, alunos.aluno_nome ASC')
      # @transferencia =  @transferencia1 + (@alunos_trasnf -  @transferencia1)

       render :update do |page|
          page.replace_html 'transf_alunos', :partial => 'transferencias_classe'
       end
end


  def unidade_transferencia
   session[:unidade_ant_id] = Unidade.find_by_nome(params[:transferencia_de])
   @alunos = Aluno.find(:all, :conditions =>['unidade_id =? AND aluno_status is null',  session[:unidade_ant_id]], :order => 'aluno_nome')
   @unidade_para = Unidade.find(:all, :conditions => ['id =?', current_user.unidade_id], :order => 'nome ASC')
   @classes = Classe.find(:all, :conditions =>['unidade_id =?',  current_user.unidade_id], :order => 'classe_classe')
   render :partial => 'selecao_alunos'






  end

  def load_dados_iniciais
       if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
         @unidade_de1 = Unidade.find(:all,:conditions =>['id > 41 AND id <52'], :order => 'nome ASC')
         @unidade_de = Unidade.find(:all,:conditions =>['id = ?', current_user.unidade_id], :order => 'nome ASC')
       else
          @unidade_de = Unidade.find(:all, :order => 'nome ASC')
       end
       @unidade_para = Unidade.find(:all, :order => 'nome ASC')
       @alunos = Aluno.find(:all, :conditions => ['aluno_status is null'],:order => 'aluno_nome')
       @classes = Classe.find(:all, :conditions =>['unidade_id=?', current_user.unidade_id],:order => 'classe_classe')
       unidade=  current_user.unidade_id
       @alunos1 = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `unidade_id`= "+unidade.to_s+" AND`id`not in (SELECT alunos_classes.aluno_id FROM classes INNER JOIN alunos_classes ON classes.id = alunos_classes.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")ORDER BY aluno_nome ASC")
       if current_user.unidade_id == 53 or current_user.unidade_id == 52
             @classe = Classe.find(:all, :order => 'classe_classe ASC')
       else
             @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
       end
       @alunos1 = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `unidade_id`= "+unidade.to_s+" AND`id`not in (SELECT alunos_classes.aluno_id FROM classes INNER JOIN alunos_classes ON classes.id = alunos_classes.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")ORDER BY aluno_nome ASC")
       #@alunos1 = Aluno.find(:all, :conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
       @alunos2 = Aluno.find(:all, :conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
       
       @alunos_transferencia = Transferencia.find_by_sql("SELECT * FROM  `transferencias` tr JOIN `alunos` al ON tr.aluno_id = al.id AND tr.unidade_id ="+current_user.unidade_id.to_s+" ORDER BY al.aluno_nome")
       
       

  end
end
