class AtividadeAvaliacaosController < ApplicationController
  # GET /atividade_avaliacaos
  # GET /atividade_avaliacaos.xml
   before_filter :load_iniciais

  def load_iniciais
        @Avaliacao = [nil,"xxx", "yyy", "10.0","9.0","8.0","7.0","6.0","5.0","4.0","3.0","2.0","1.0","0.0"]
  end
  def index
    @atividade_avaliacaos = AtividadeAvaliacao.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atividade_avaliacaos }
    end
  end

  # GET /atividade_avaliacaos/1
  # GET /atividade_avaliacaos/1.xml
  def show
    @atividade_avaliacao = AtividadeAvaliacao.find(params[:id])
@atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', @atividade_avaliacao.classe_id , @atividade_avaliacao.professor_id, @atividade_avaliacao.disciplina_id, Time.now.year])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atividade_avaliacao }
    end
  end

  # GET /atividade_avaliacaos/new
  # GET /atividade_avaliacaos/new.xml
  def new
    @atividade_avaliacao = AtividadeAvaliacao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atividade_avaliacao }
    end
  end

  # GET /atividade_avaliacaos/1/edit
  def edit
      w= params[:id]
      t=0
    @atividade_avaliacao = AtividadeAvaliacao.find(params[:id])
    @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', @atividade_avaliacao.classe_id , @atividade_avaliacao.professor_id, @atividade_avaliacao.disciplina_id, Time.now.year])
  end

  # POST /atividade_avaliacaos
  # POST /atividade_avaliacaos.xml
  def create
    @atividade_avaliacao = AtividadeAvaliacao.new(params[:atividade_avaliacao])

    respond_to do |format|
      if @atividade_avaliacao.save
        flash[:notice] = 'AtividadeAvaliacao was successfully created.'
        format.html { redirect_to(@atividade_avaliacao) }
        format.xml  { render :xml => @atividade_avaliacao, :status => :created, :location => @atividade_avaliacao }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @atividade_avaliacao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /atividade_avaliacaos/1
  # PUT /atividade_avaliacaos/1.xml
  def update
    @atividade_avaliacao = AtividadeAvaliacao.find(params[:id])

    respond_to do |format|
      if @atividade_avaliacao.update_attributes(params[:atividade_avaliacao])
        flash[:notice] = 'AtividadeAvaliacao was successfully updated.'
        format.html { redirect_to(@atividade_avaliacao) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @atividade_avaliacao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /atividade_avaliacaos/1
  # DELETE /atividade_avaliacaos/1.xml
  def destroy
    @atividade_avaliacao = AtividadeAvaliacao.find(params[:id])
    @atividade_avaliacao.destroy

    respond_to do |format|
      format.html { redirect_to(atividade_avaliacaos_url) }
      format.xml  { head :ok }
    end
  end

    def update_multiplas_atividades
        AtividadeAvaliacao.update(params[:atividade_avaliacao].keys, params[:atividade_avaliacao].values)
        flash[:notice] = 'AVALIÇÂO ATIVIDADES.'
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id],Time.now.year])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
        @notas = Nota.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND atribuicaos.disciplina_id=? AND notas.ano_letivo=?",   session[:classe_id] , session[:professor_id], session[:disc_id],Time.now.year ],:readonly => false,:order => 'matriculas.classe_num ASC')
#        for nota_somaf in @notas
#            soma=0
#            if !nota_somaf.faltas1.nil?
#                soma=soma+nota_somaf.faltas1.to_i
#            end
#            if !nota_somaf.faltas2.nil?
#                soma=soma+nota_somaf.faltas2.to_i
#            end
#            if !nota_somaf.faltas3.nil?
#                soma=soma+nota_somaf.faltas3.to_i
#            end
#            if !nota_somaf.faltas4.nil?
#                soma=soma+nota_somaf.faltas4.to_i
#            end
#            nota_somaf.faltas5 = soma
#            nota_somaf.save
 #       end
        render 'atividades_lancamentos_multiplos'
    end
def avaliacao_atividades

 @atividade = Atividade.find(params[:id])
 #@atividade_avaliacao= AtividadeAvaliacao.find(:all, :select => ' matriculas.aluno_id, matriculas.classe_num, atividades.*',:joins=> 'INNER JOIN atividades ON atividades.id = atividade_avaliacaos.atividade_id INNER JOIN classes ON classes.id = atividades.classe_id INNER JOIN matriculas ON classes.id = matriculas.classe_id', :conditions =>  ['atividades.professor_id=? and	atividades.classe_id =?  and	atividades.disciplina_id=?',  session[:professor], session[:classe] , session[:disciplina]])
 @atividade_avaliacao= AtividadeAvaliacao.find(:all, :conditions =>  ['atividade_avaliacaos.professor_id=? and classe_id =?  and	disciplina_id=?',  session[:professor], session[:classe] , session[:disciplina]])
 @atribuicao_classe= Atribuicao.find(:all, :conditions=> ['id =?', @atividade.atribuicao_id])
  end

def valiadar_atividades
t=0
    w11=    w=session[:Ix]=params[:atividade_avaliacao_inicio]

          #session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
    w10=    session[:Fx]= params[:fim]
t=0

   w1=     session[:dataI]=params[:atividade][:inicio][6,4]+'-'+params[:atividade][:inicio][3,2]+'-'+params[:atividade][:inicio][0,2]
    w2=    session[:dataF]=params[:atividade][:fim][6,4]+'-'+params[:atividadeo][:fim][3,2]+'-'+params[:atividade][:fim][0,2]
    w3=    session[:mes]=params[:atividade][:fim][3,2]
    w4=    session[:anoI]=params[:atividade][:inicio][6,4]
    w5=    session[:anoF]=params[:atividade][:fim][6,4]
    t=0
 #@atividade = Atividade.find(params[:id])
 #@atividade_avaliacao= AtividadeAvaliacao.find(:all, :select => ' matriculas.aluno_id, matriculas.classe_num, atividades.*',:joins=> 'INNER JOIN atividades ON atividades.id = atividade_avaliacaos.atividade_id INNER JOIN classes ON classes.id = atividades.classe_id INNER JOIN matriculas ON classes.id = matriculas.classe_id', :conditions =>  ['atividades.professor_id=? and	atividades.classe_id =?  and	atividades.disciplina_id=?',  session[:professor], session[:classe] , session[:disciplina]])
 @atividades= Atividade.find(:all, :conditions =>  ['professor_id=? and classe_id =?  and	disciplina_id=?',  session[:professor], session[:classe] , session[:disciplina]])
 @atividade_avaliacao= AtividadeAvaliacao.find(:all, :conditions =>  ['professor_id=? and classe_id =?  and	disciplina_id=?',  session[:professor], session[:classe] , session[:disciplina]])
 @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=? AND ano_letivo=?', session[:classe_id] , session[:professor_id], session[:disc_id], Time.now.year])
 
# @atribuicao_classe= Atribuicao.find(:all, :conditions=> ['id =?', @atividade.atribuicao_id])

  end


end
