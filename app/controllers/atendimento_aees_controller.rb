class AtendimentoAeesController < ApplicationController
  # GET /atendimento_aees
  # GET /atendimento_aees.xml
  def index
    @atendimento_aees = AtendimentoAee.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atendimento_aees }
    end
  end

  # GET /atendimento_aees/1
  # GET /atendimento_aees/1.xml
  def show
    @atendimento_aee = AtendimentoAee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atendimento_aee }
    end
  end

  # GET /atendimento_aees/new
  # GET /atendimento_aees/new.xml
  def new
    @atendimento_aee = AtendimentoAee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atendimento_aee }
    end
  end

  # GET /atendimento_aees/1/edit
  def edit
    @atendimento_aee = AtendimentoAee.find(params[:id])
  end

  # POST /atendimento_aees
  # POST /atendimento_aees.xml
  def create
    @atendimento_aee = AtendimentoAee.new(params[:atendimento_aee])
    classe_num = 0
    respond_to do |format|
      if @atendimento_aee.save
          @atendimento_aee.classe_mat= session[:cclasse_id]
         wq= @atendimento_aee.aluno_id  = session[:aaluno_id]
         t=0
         # @atendimento_aee.unidade  = session[:uunidade]
          @atendimento_aee.ano_letivo = Time.now.year
          @atendimento_aee.save
        flash[:notice] = 'Atendimento AEE Cadastrado.'
           classe_num = (AtendimentoAee.find(:all, :conditions => ['classe_id =? AND ano_letivo=? ',   @atendimento_aee.classe_id, Time.now.year ]).count)
           if  classe_num == 1
             @atendimento_aee.classe_num = classe_num = 1

           else
              @atendimento_aee.classe_num = classe_num 

         end
           @atendimento_aee.save

        format.html { redirect_to(@atendimento_aee) }
        format.xml  { render :xml => @atendimento_aee, :status => :created, :location => @atendimento_aee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @atendimento_aee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /atendimento_aees/1
  # PUT /atendimento_aees/1.xml
  def update
    @atendimento_aee = AtendimentoAee.find(params[:id])

    respond_to do |format|
      if @atendimento_aee.update_attributes(params[:atendimento_aee])
        flash[:notice] = 'AtendimentoAee was successfully updated.'
        format.html { redirect_to(@atendimento_aee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @atendimento_aee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimento_aees/1
  # DELETE /atendimento_aees/1.xml
  def destroy
    @atendimento_aee = AtendimentoAee.find(params[:id])
    @atendimento_aee.destroy

    respond_to do |format|
      format.html { redirect_to(home_path) }
      format.xml  { head :ok }
    end
  end

  def aluno_classe
        w5 = session[:aaluno_id]=params[:relatorio_aluno_id]
      


      t=0
         @matricula= Matricula.find(:all, :conditions=> ['aluno_id = ? AND (status =? OR status =?) AND ano_letivo =?' , session[:aaluno_id],"MATRICULADO","TRANSFERENCIA", Time.now.year	])
        
         w2=session[:cclasse_id]= @matricula[0].classe.classe_classe
         w=session[:uunidade] = @matricula[0].unidade.nome
t=0
      render :partial => 'aluno_classe'
  end


  def aluno_unidade
           

#          @alunos_matricula = Aluno.find_by_sql("SELECT a.id, CONCAT(a.aluno_nome, ' | ',date_format(a.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn FROM alunos a WHERE ( aluno_status != 'EGRESSO' or aluno_status is null OR aluno_status = 'ABANDONO') AND a.unidade_id = "+(params[:unidade_id]).to_s+" AND ( id IN (SELECT m.aluno_id FROM matriculas m WHERE m.ano_letivo = "+(Time.now.year).to_s+" AND m.status != 'ABANDONO')) ORDER BY a.aluno_nome")
          @alunos_matricula = Matricula.find(:all,:select => "alunos.id, CONCAT(alunos.aluno_nome, ' | ',date_format(alunos.aluno_nascimento, '%d/%m/%Y')) AS aluno_nome_dtn ", :joins => "inner join alunos on alunos.id = matriculas.aluno_id ", :conditions=> [" ( (alunos.aluno_status != 'EGRESSO' or alunos.aluno_status is null OR alunos.aluno_status = 'ABANDONO') AND alunos.unidade_id = ? AND (matriculas.ano_letivo = ? AND matriculas.status != 'ABANDONO'))  ", params[:unidade_id], Time.now.year ], :order => "alunos.aluno_nome")

            t=0

      render :partial => 'aluno_unidade'
  end

end
