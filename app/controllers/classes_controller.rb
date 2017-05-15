class ClassesController < ApplicationController

  # before_filter :load_professors
  before_filter :load_classes
  # before_filter :load_alunos
  


  def index
    @classes = Classe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classes }
    end
  end



  def new
    @classe = Classe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @classe }
    end
  end

  def edit
    @classe = Classe.find(params[:id])
    session[:classe_id]=(params[:id])
    @alunos_selecionados = @classe.alunos
    @alunos = @alunos - @alunos_selecionados
  end

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

  def update
    @alunosA = Aluno.find(:all,:joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', session[:classe_id]])
    @classe = Classe.find(params[:id])
    respond_to do |format|
      if @classe.update_attributes(params[:classe])
       @alunosD = Aluno.find(:all,:joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', session[:classe_id]])
       @aluno = @alunosD -@alunosA
       for aluno in @aluno
          session[:id_aluno]= aluno.id
          session[:classe]= @classe.id
          @atribuicao= Atribuicao.find(:all, :conditions=>['classe_id=? AND ativo=?', @classe.id, 0 ])
          for atrib in @atribuicao
           session[:classe]= atrib.classe_id
           session[:atribuicao]= atrib.id
           session[:disciplina]= atrib.disciplina_id
           session[:professor]= atrib.professor_id
           @alunos1 = Aluno.find(:all, :joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', session[:classe]])
           @aluno3 = Aluno.find(:all, :conditions => ['id = ?', session[:id_aluno]])
           if (current_user.unidade_id > 41  and  current_user.unidade_id < 52)
           for alun in @aluno3
             n=(params[:nota])
                @nota = Nota.new(params[:nota])
                @nota.aluno_id = alun.id
                @nota.disciplina_id = session[:disciplina]
                @nota.atribuicao_id= session[:atribuicao]
                @nota.professor_id= session[:professor]
                @nota.unidade_id= current_user.unidade_id
                @nota.ano_letivo =  Time.now.year
                @nota.nota1 = nil
                @nota.faltas1 = nil
                @nota.nota2 = nil
                @nota.faltas2 = nil
                @nota.nota3 = nil
                @nota.faltas3 = nil
                @nota.nota4 = nil
                @nota.faltas4 = nil
                @nota.nota5 = nil
                @nota.faltas5= nil
                @nota.save
              end
            end
          end
         end
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@classe) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @classe.errors, :status => :unprocessable_entity }
      end
    end
  end

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
  results = ActiveRecord::Base.connection.execute("DELETE FROM `matriculas` WHERE `aluno_id`="+(aluno_id).to_s+ " and classe_id="+(classe_id).to_s)

end

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


#  def load_professors
#    if current_user.unidade_id == 53 or current_user.unidade_id == 52
#        @professors = Professor.find(:all,:conditions =>'desligado = 0', :order => 'nome ASC')
#    else
#        @professors = Professor.find(:all, :conditions => ['desligado = 0 AND (unidade_id = ? or unidade_id = 54)', current_user.unidade_id  ],:order => 'matricula ASC')
#    end
#  end


def consulta_classe_aluno

       session[:classe_id]=params[:classe][:id]
       
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')

        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end

def consulta_piloto

       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_piloto'
       end
end

def editar_classe_aluno
       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe_editar'
       end
end

def gerar_notas
       session[:classe_id]
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0])
       for matricula in @matriculas
         @notas_inicial = Nota.find(:all, :conditions=>['aluno_id =? and ano_letivo =?', matricula.aluno_id,  Time.now.year])
          session[:matricula_aluno_id] = matricula.aluno_id
          for atribuicao in @atribuicao_classe
               @notas_atribuicao_classe = Nota.find(:all,:conditions =>['aluno_id = ? AND ano_letivo=? AND disciplina_id=?', matricula.aluno_id,Time.now.year, atribuicao.disciplina_id])
                if @notas_atribuicao_classe.empty?
                       session[:classe]= atribuicao.classe_id
                       session[:atribuicao]= atribuicao.id
                       session[:professor]= atribuicao.professor_id
                       session[:disciplina]= atribuicao.disciplina_id
                                 if (current_user.unidade_id > 41  and  current_user.unidade_id < 52) or (current_user.unidade_id == 62)
                                      @nota = Nota.new(params[:nota])
                                      @nota.aluno_id = matricula.aluno_id
                                      @nota.atribuicao_id= session[:atribuicao]
                                      @nota.matricula_id= matricula.id
                                      @nota.professor_id= session[:professor]
                                      @nota.unidade_id= current_user.unidade_id
                                      @nota.disciplina_id = session[:disciplina]
                                      @nota.ano_letivo =  Time.now.year
                                      if (matricula.status == 'TRANSFERIDO')
                                         @nota.nota1 = 'TR'
                                      else
                                         @nota.nota1 = nil
                                      end
                                      @nota.faltas1 = 0
                                      @nota.aulas1 = 0
#                                      if (matricula.status == 'TRANSFERIDO')
#                                         @nota.nota2 = 'TR'
#                                      else
                                         @nota.nota2 = nil
#                                      end
                                      @nota.faltas2 = 0
                                      @nota.aulas2 = 0
#                                      if (matricula.status == 'TRANSFERIDO')
#                                         @nota.nota3 = 'TR'
#                                      else
                                         @nota.nota3 = nil
#                                      end
                                      @nota.faltas3 = 0
                                      @nota.aulas3 = 0
 #                                     if (matricula.status == 'TRANSFERIDO')
 #                                        @nota.nota4 = 'TR'
 #                                     else
                                         @nota.nota4 = nil
 #                                     end
                                      @nota.faltas4 = 0
                                      @nota.aulas4 = 0
#                                      if (matricula.status == 'TRANSFERIDO')
#                                         @nota.nota5 = 'TR'
#                                      else
                                         @nota.nota5 = nil
#                                      end
                                      @nota.faltas5 = 0
                                      @nota.aulas5 = 0
                                        if @nota.save
                                           flash[:notice] = 'NOTAS CRIADAS COM SUCESSO!'
                                        end
                                 end
                   
               end
          end


          if ((matricula.status == 'REMANEJADO' or matricula.status == 'TRANSFERIDO') and (!matricula.transf_unidade_id.nil?))
             @notas_aluno = Nota.find(:all, :conditions=>['aluno_id =? and ano_letivo =?', matricula.aluno_id,  Time.now.year])
             @notas_matricula = Nota.find(:all, :conditions=>['aluno_id =? and matricula_id =? and ano_letivo =?', matricula.aluno_id, matricula.id,  Time.now.year])

 #            w= matricula.id
 #            t=0
             
 #            t=0
                 for notas in @notas_inicial
#                   @notas_teste = Nota.find(:all, :conditions=>['aluno_id =? and matricula_id=? and disciplina_id=?', matricula.aluno_id, notas.matricula_id, notas.disciplina_id])
                    @notas_matricula = Nota.find(:all, :conditions=>['aluno_id =? and matricula_id =? and ano_letivo =? and disciplina_id =?', matricula.aluno_id, matricula.id,  Time.now.year, notas.disciplina_id])
 #                   if !@notas_matricula.empty?
 #                      w=@notas_matricula[0].id
 #                      w1= notas_matricula=@notas_matricula[0].id
#
  #                  end
#                  if !@notas_teste[0].unidade_id == notas.unidade_id
                       session[:professor]= notas.professor_id
                       session[:disciplina]= notas.disciplina_id
                       session[:disciplina]
                       notas.aluno_id
                       session[:classe_id]
                       session[:nova_unidade]
                       @atribuicao_1= Atribuicao.find(:all, :select=> 'id', :conditions => ['disciplina_id=? and ano_letivo=? and classe_id=?', session[:disciplina], Time.now.year, session[:classe_id]])
                         session[:atribuicao]= @atribuicao_1[0].id
                                 if (current_user.unidade_id > 41  and  current_user.unidade_id < 52) or (current_user.unidade_id == 62)
                                      @nota = Nota.new(params[:nota])
                                      @nota.aluno_id = matricula.aluno_id
                                      @nota.atribuicao_id= session[:atribuicao]
                                      @nota.matricula_id= matricula.id
                                      @nota.professor_id= session[:professor]
                                      @nota.unidade_id= current_user.unidade_id
                                      @nota.disciplina_id = session[:disciplina]
                                      @nota.ano_letivo =  Time.now.year
                                       for matricula1 in @matriculas
                                          if (matricula1.status == 'TRANSFERIDO' and !matricula.transf_unidade_id.nil?)
                                             @nota.nota1 = 'TR'
                                          else
                                             @nota.nota1 = notas.nota1
                                          end
                                          @nota.faltas1 = notas.faltas1
                                          @nota.aulas1 = notas.aulas1
                                          if (matricula1.status == 'TRANSFERIDO' and !matricula.transf_unidade_id.nil?)
                                             @nota.nota2 = 'TR'
                                          else
                                             @nota.nota2 = notas.nota2
                                          end
                                          @nota.faltas2 = notas.faltas2
                                          @nota.aulas2 = notas.aulas2
                                          if (matricula1.status == 'TRANSFERIDO' and !matricula.transf_unidade_id.nil?)
                                             @nota.nota3 = 'TR'
                                          else
                                             @nota.nota3 = notas.nota3
                                          end
                                          @nota.faltas3 = notas.faltas3
                                          @nota.aulas3 = notas.aulas3
                                          if (matricula1.status == 'TRANSFERIDO' and !matricula.transf_unidade_id.nil?)
                                             @nota.nota4 = 'TR'
                                          else
                                             @nota.nota4 = notas.nota4
                                          end
                                          @nota.faltas4 = notas.faltas4
                                          @nota.aulas4 = notas.aulas4
                                          if (matricula1.status == 'TRANSFERIDO' and !matricula.transf_unidade_id.nil?)
                                             @nota.nota5 = 'TR'
                                          else
                                             @nota.nota5 = notas.nota5
                                          end
                                          @nota.faltas5 = notas.faltas5
                                          @nota.aulas5 = notas.aulas5
                                       end
                                       if @nota.save
                                          flash[:notice] = 'NOTAS CRIADAS COM SUCESSO!'
                                      end
                               end
                   end


          end

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
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id], 0])
       t1=session[:classe_id]

       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',  session[:classe_id]], :order => 'classe_num ASC')
      render :layout => "impressao"
end


def impressao_piloto
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
       render :layout => "impressao"
end

def impressao_lista
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',  session[:classe_id]], :order => 'classe_num ASC')

      render :layout => "impressao"
end

def consulta_lista_classe
       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')

        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_lista'
       end
end

  def classes_ano
        @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id]    )
   render :partial => 'selecao_classe'
  end



 def load_classes
   @ano =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo ASC')
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classe = Classe.find(:all, :order => 'classe_classe ASC')
        #@classe_todas =  Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        #@classe_todas =  Classe.find(:all, :conditions => ['unidade_id = ? ', current_user.unidade_id  ], :order => 'classe_ano_letivo ASC, classe_classe ASC')
        @classe_td =  Classe.find(:all,:select => 'distinct(classe_ano_letivo)',:order => 'classe_ano_letivo ASC')

    end
 end


#  def load_alunos
#   if current_user.unidade_id == 53 or current_user.unidade_id == 52
#        @alunos = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `id`not in (SELECT matriculas.aluno_id FROM classes INNER JOIN matriculas ON classes.id = matriculas.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+") ORDER BY aluno_nome ASC")
#    else
#        @alunos = Aluno.find_by_sql("SELECT * FROM `alunos` WHERE `unidade_id`= "+(current_user.unidade_id).to_s+" AND`id`not in (SELECT matriculas.aluno_id FROM classes INNER JOIN matriculas ON classes.id = matriculas.classe_id where classes.classe_ano_letivo = "+(Time.now.year).to_s+")ORDER BY aluno_nome ASC")
#    end

# end
end
