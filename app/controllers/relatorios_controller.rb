class RelatoriosController < ApplicationController
  # GET /relatorios
  # GET /relatorios.xml
   before_filter :load_dados_iniciais


  def index
    @relatorios = Relatorio.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @relatorios }
    end
  end

  # GET /relatorios/1
  # GET /relatorios/1.xml
  def show
    @relatorio = Relatorio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/new
  # GET /relatorios/new.xml
  def new
    @relatorio = Relatorio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/1/edit
  def edit
    @relatorio = Relatorio.find(params[:id])
  end

  # POST /relatorios
  # POST /relatorios.xml
  def create
    @relatorio = Relatorio.new(params[:relatorio])
    @relatorio.ano_letivo =  Time.now.year
    @relatorio.professor_id = session[:professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =?", session[:professor_id] ])
    @relatorio.atribuicao_id= @atribuicao[0].id

    respond_to do |format|
      if @relatorio.save
        flash[:notice] = 'RELATORIO SALVO COM SUCESSO'
        format.html { redirect_to(@relatorio) }
        format.xml  { render :xml => @relatorio, :status => :created, :location => @relatorio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /relatorios/1
  # PUT /relatorios/1.xml
  def update
    @relatorio = Relatorio.find(params[:id])

    respond_to do |format|
      if @relatorio.update_attributes(params[:relatorio])
        flash[:notice] = 'RELATORIO SALVO COM SUCESSO'
        format.html { redirect_to(@relatorio) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /relatorios/1
  # DELETE /relatorios/1.xml
  def destroy
    @relatorio = Relatorio.find(params[:id])
    @relatorio.destroy

    respond_to do |format|
      format.html { redirect_to(relatorios_url) }
      format.xml  { head :ok }
    end
  end


  def professor
    session[:professor_id]=params[:relatorio_professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =?", session[:professor_id] ])
       render :update do |page|
          page.replace_html 'dados_prof', :partial => 'classe'
       end

  end


  def consulta_relatorio
      @relatorio = Relatorio.find(:all, :conditions => ['aluno_id =?', params[:aluno_id]])



  end



  def relatorio
     if ( params[:aluno].present?)
      @relatorios = Relatorio.find(:all, :conditions => ["aluno_id =?", params[:aluno]])
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @relatorios }
        end
    end
  end


  def dados
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =?", session[:professor_id] ])
    render :update do |page|
          page.replace_html 'dados_aluno', :partial => 'dados'
       end
  end

  def load_dados_iniciais
       unidade=  current_user.unidade_id
       if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id > 41 AND id <52'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all,:conditions =>['id = ?', current_user.unidade_id], :order => 'nome ASC')
       else
         @unidade_procedencia1 = Unidade.find(:all,:conditions =>['id < 40  OR id >51'], :order => 'nome ASC')
         @unidade_procedencia = Unidade.find(:all, :order => 'nome ASC')
       end

       @alunos = Aluno.find(:all, :conditions => ['aluno_status is null'],:order => 'aluno_nome')
       @alunos1 = Aluno.find_by_sql("SELECT * FROM alunos  WHERE unidade_id= "+unidade.to_s+" AND`id` NOT IN
                       (SELECT matriculas.aluno_id FROM matriculas INNER JOIN alunos ON alunos.id = matriculas.aluno_id WHERE matriculas.ano_letivo = "+(Time.now.year).to_s+" AND matriculas.status <> 'TRANSFERIDO' AND alunos.unidade_id = "+unidade.to_s+")
                        ORDER BY aluno_nome ASC")

       @alunos2 = Aluno.find(:all, :conditions =>['unidade_id=? AND aluno_status is null', current_user.unidade_id],:order => 'aluno_nome')
       @alunos3 = Aluno.find(:all, :joins => "INNER JOIN matriculas ON alunos.id = matriculas.aluno_id", :conditions =>['alunos.unidade_id=? AND (matriculas.status = "MATRICULADO" OR matriculas.status = "*REMANEJADO" OR matriculas.status = "TRANSFERENCIA")  ', current_user.unidade_id],:order => 'alunos.aluno_nome')
       @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')


  end


end
