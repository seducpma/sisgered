class FaltasController < ApplicationController
  def index
    @faltas = Falta.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @faltas }
    end
  end

  def show
    @falta = Falta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @falta }
    end
  end

 def new
    @falta = Falta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @falta }
    end
  end

  def edit
    @falta = Falta.find(params[:id])
  end

  def create
    @falta = Falta.new(params[:falta])
    respond_to do |format|
      if @falta.save
        flash[:notice] = 'Falta was successfully created.'
        format.html { redirect_to(@falta) }
        format.xml  { render :xml => @falta, :status => :created, :location => @falta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @falta.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @falta = Falta.find(params[:id])
    session[:classe_id]= @falta.atribuicao.classe_id
    respond_to do |format|
      if @falta.update_attributes(params[:falta])
          flash[:notice] = 'SALVO COM SUCESSO'
        format.html { redirect_to(@falta) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @falta.errors, :status => :unprocessable_entity }
      end
    end


  end

  def destroy
    @falta = Falta.find(params[:id])
    @falta.destroy

    respond_to do |format|
      format.html { redirect_to(faltas_url) }
      format.xml  { head :ok }
    end
  end

 def lancar_faltas_inf
 end

    def lancar_faltas_infantil
            w1=session[:professor_id]= params[:professor][:id]
            w2=session[:current_user_unidade_id]= current_user.unidade_id
            w3=  session[:classe_id]
            @classe = Classe.find(:all, :conditions =>['id = ? AND classe_ano_letivo=?', session[:classe_id],Time.now.year])
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['professor_id =? AND ano_letivo=?',  session[:professor_id], Time.now.year])
            for atrib in @atribuicao_classe
                session[:atrib_id] = atrib.id
            end
                render :update do |page|
                    page.replace_html 'faltas', :partial => 'aulas_faltas'
                end
    end

  def voltar_lancamento_faltas
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and ano_letivo=?', session[:classe_id], session[:professor_id], Time.now.year])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and ano_letivo =?', session[:classe_id], session[:professor_id], Time.now.year])
        for atrib in @atribuicao_classe
            w4=session[:atrib_id] = atrib.id

        end
        @faltas = Falta.find(:all, :joins => [:aluno], :conditions => ["faltas.ano_letivo=? and faltas.classe_id=? and faltas.ativo is null" ,Time.now.year , session[:classe_id] ])
        if current_user.has_role?('professor_infantil') or  current_user.has_role?('secretaria_infantil')or  current_user.has_role?('diretor_infantil')
            session[:conta]=0
            render "faltas_lancamentos_multiplos", :layout => "layouts/application"
        else
            render "faltas_lancamentos", :layout => "layouts/application"
        end
    end

 def professor_classe
     session[:nome_professor] = Professor.find_by_id(params[:professor_id]).nome
     @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.ano_letivo= ?  and atribuicaos.professor_id = ?', Time.now.year, params[:professor_id]])
          w=session[:classe_id]=@classe[0].id
         render :partial => 'professor_classe'
 end

def action_classe_id
    session[:classe_id]= params[:classe_id]
end


def gerar_faltas_todas
    @matriculas_infantil = Matricula.find(:all, :select => 'classes.id as classe_id , classes.unidade_id, classes.classe_classe, unidades.nome, unidades.tipo_id, matriculas.id as matricula_id, matriculas.aluno_id as aluno_id ', :joins => "INNER JOIN classes ON matriculas.classe_id = classes.id INNER JOIN unidades on unidades.id = classes.unidade_id ", :conditions =>['matriculas.ano_letivo =? AND (classes.unidade_id < 42 OR classes.unidade_id > 51 )AND classes.unidade_id !=62', Time.now.year])
    for aluno in @matriculas_infantil
        @faltas_aluno = Falta.find(:all, :select => 'id', :conditions =>['aluno_id = ? AND classe_id=? AND ano_letivo=? AND matricula_id=?', aluno.aluno_id, aluno.classe_id, Time.now.year, aluno.matricula_id])
                if @faltas_aluno.empty?
                                      @falta = Falta.new(params[:falta])
                                      @falta.aluno_id = aluno.aluno_id
                                      @falta.classe_id= aluno.classe_id
                                      @falta.matricula_id= aluno.matricula_id
                                      #@falta.professor_id= aluno.professor_id
                                      @falta.unidade_id= aluno.unidade_id
                                      @falta.ano_letivo =  Time.now.year
                                      @falta.faltas1 = 0
                                      @falta.aulas1 = 0
                                      @falta.faltas2 = 0
                                      @falta.aulas2 = 0
                                      @falta.faltas3 = 0
                                      @falta.aulas3 = 0
                                      @falta.faltas4 = 0
                                      @falta.aulas4 = 0
                                      @falta.faltas5 = 0
                                      @falta.aulas5 = 0

                                        if @falta.save
                                           session[:created]=@falta.created_at
                                           flash[:notice] = 'FALTAS CRIADAS COM SUCESSO!'
                                        end
                                 end
          end

        flash[:notice] = 'GERAÇÂO DE FALTAS CONCLUIDAS COM SUCESSO!'
end


def gerar_faltas
    w= session[:classe_id]
    @matriculas_infantil = Matricula.find(:all, :select => 'classes.id as classe_id , classes.unidade_id, classes.classe_classe, unidades.nome, unidades.tipo_id, matriculas.id as matricula_id, matriculas.aluno_id as aluno_id ', :joins => "INNER JOIN classes ON matriculas.classe_id = classes.id INNER JOIN unidades on unidades.id = classes.unidade_id ", :conditions =>['matriculas.ano_letivo =? AND (classes.unidade_id < 42 OR classes.unidade_id > 51 )AND classes.unidade_id !=62 AND matriculas.classe_id =?', Time.now.year, session[:classe_id]])
    for aluno in @matriculas_infantil
        @faltas_aluno = Falta.find(:all, :select => 'id', :conditions =>['aluno_id = ? AND classe_id=? AND ano_letivo=? AND matricula_id=?', aluno.aluno_id, aluno.classe_id, Time.now.year, aluno.matricula_id])
                if @faltas_aluno.empty?
                                      @falta = Falta.new(params[:falta])
                                      @falta.aluno_id = aluno.aluno_id
                                      @falta.classe_id= aluno.classe_id
                                      @falta.matricula_id= aluno.matricula_id
                                      #@falta.professor_id= aluno.professor_id
                                      @falta.unidade_id= aluno.unidade_id
                                      @falta.ano_letivo =  Time.now.year
                                      @falta.faltas1 = 0
                                      @falta.aulas1 = 0
                                      @falta.faltas2 = 0
                                      @falta.aulas2 = 0
                                      @falta.faltas3 = 0
                                      @falta.aulas3 = 0
                                      @falta.faltas4 = 0
                                      @falta.aulas4 = 0
                                      @falta.faltas5 = 0
                                      @falta.aulas5 = 0
                                        if @falta.save
                                           session[:created]=@falta.created_at
                                           flash[:notice] = 'FALTAS CRIADAS COM SUCESSO!'
                                        end
                                 end
          end
        flash[:notice] = 'FALTAS GERADAS CONCLUIDAS COM SUCESSO!'
  end



  def update_multiplas_faltas
        Falta.update(params[:falta].keys, params[:falta].values)
        flash[:notice] = 'FALTAS  LANÇADAS.'
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ?  AND ano_letivo=?', session[:classe_id] , session[:professor_id],Time.now.year])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? AND ano_letivo=?', session[:classe_id] , session[:professor_id], Time.now.year])
         w=session[:classe_id] 
         w1= session[:professor_id]
        #@faltas = Falta.find(:all, :joins => [:atribuicao,:matricula], :conditions => ["atribuicaoss.classe_id =? AND atribuicaos.professor_id =?  AND  faltas.ano_letivo = ?",   session[:classe_id] , session[:professor_id],Time.now.year ],:readonly => false,:order => 'matriculas.classe_num ASC')
        @faltas = Falta.find(:all,  :conditions => ["classe_id =?  AND  ano_letivo = ?",   session[:classe_id] , Time.now.year ],:readonly => false)
        for falta in @faltas
            soma=0
            if !falta.faltas1.nil?
                soma=soma+falta.faltas1.to_i
            end
            if !falta.faltas2.nil?
                soma=soma+falta.faltas2.to_i
            end
            if !falta.faltas3.nil?
                soma=soma+falta.faltas3.to_i
            end
            if !falta.faltas4.nil?
                soma=soma+falta.faltas4.to_i
            end
            falta.faltas5 = soma
           w=session[:falta_id] = falta.id
          @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? AND ano_letivo=?', session[:classe_id] , session[:professor_id], Time.now.year])
           for atrib in  @atribuicao_classe
                falta.aulas1 = atrib.aulas1
                falta.aulas2 = atrib.aulas2
                falta.aulas3 = atrib.aulas3
                falta.aulas4 = atrib.aulas4
            end
           falta.aulas5 = falta.aulas1 + falta.aulas2 + falta.aulas3 + falta.aulas4
           if (falta.aulas1 == 0)
                falta.freq1= 100
           else
                 falta.freq1= 100 - (((falta.faltas1).to_f / (falta.aulas1).to_f)*100).to_i
           end
           if (falta.aulas2 == 0)
                falta.freq2= 100
           else
                falta.freq2= 100 - (((falta.faltas2).to_f / (falta.aulas2).to_f)*100).to_i
           end
           if (falta.aulas3 == 0)
                falta.freq3= 100
           else
               falta.freq3= 100 - (((falta.faltas3).to_f / (falta.aulas3).to_f)*100).to_i
           end
           if (falta.aulas4 == 0)
                falta.freq4= 100
           else
               falta.freq4= 100 - (((falta.faltas4).to_f / (falta.aulas4).to_f)*100).to_i
           end
           if (falta.aulas5 == 0)
                falta.freq5= 100
           else
                falta.freq5= 100 - (((falta.faltas5).to_f / (falta.aulas5).to_f)*100).to_i
           end
           falta.save
        end
        render 'faltas_lancamentos_multiplos'
    end


def relatorio_unidade_falta
        w=session[:unidade_id] = params[:unidade][:id]
        @classes = Classe.find(:all, :select => 'classes.id, classes.unidade_id, classes.classe_classe, unidades.nome, unidades.tipo_id', :joins => "INNER JOIN unidades on unidades.id = classes.unidade_id", :conditions =>['classes.unidade_id= ? AND classes.classe_ano_letivo= ? AND (unidades.tipo_id = 2 or unidades.tipo_id = 5 or unidades.tipo_id = 8) AND unidades.desativada =0', session[:unidade_id], Time.now.year],  :order => 'unidades.nome')
        render :update do |page|
          page.replace_html 'relatorio', :partial => 'relatorio_unidade'
       end

end




def relatorio_falta_classe
    
end

def relatorio_classe_falta
        w=session[:classe_id] = params[:classe][:id]
            a=session[:classe_id] = params[:classe][:id]
            @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
            @classe.each do |classe|
                a=session[:num_classe]= classe.classe_classe[0,1].to_i
                t=0
             end
           @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?  and ano_letivo=?', session[:classe_id],  Time.now.year])
           @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
           @faltas_alu=Falta.find(:all, :select => 'faltas.*, 	matriculas.classe_num as classe_num,	matriculas.ano_letivo, 	matriculas.status as status',  :joins => "INNER JOIN matriculas ON matriculas.id = faltas.matricula_id", :conditions => ["matriculas.classe_id =? AND matriculas.ano_letivo=?", session[:classe_id], Time.now.year])

       render :update do |page|
          page.replace_html 'relatorio', :partial => 'relatorio_classe'
       end
   
end
def impressao_relatorio_faltas_classe
    
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
            @classe.each do |classe|
                a=session[:num_classe]= classe.classe_classe[0,1].to_i
                t=0
             end
           @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?  and ano_letivo=?', session[:classe_id],  Time.now.year])
           @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
           #@matriculas_classe = Matricula.find(:all,:joins => "INNER JOIN  faltas ON faltas.matricula_id ",:conditions =>['matriculas.classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
           @faltas_alu=Falta.find(:all, :select => 'faltas.*, 	matriculas.classe_num as classe_num,	matriculas.ano_letivo, 	matriculas.status as status',  :joins => "INNER JOIN matriculas ON matriculas.id = faltas.matricula_id", :conditions => ["matriculas.classe_id =? AND matriculas.ano_letivo=?", session[:classe_id], Time.now.year])

       render :layout => "impressao"
end
end
