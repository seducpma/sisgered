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
#    @alunos = @alunos - @alunos_selecionados
  end

   def show
    @classe = Classe.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @classe }
    end
   end


  def create
    @classe = Classe.new(params[:classe])

      if current_user.unidade_id != 1 
         session[:classe]= params[:num]+" "+params[:letra]
      else
        session[:classe]= @classe.classe_classe
      end
    @verifica = Classe.find(:all,  :select => 'id', :conditions => ['classe_classe =? AND classe_ano_letivo=? AND unidade_id=?',session[:classe], @classe.classe_ano_letivo,current_user.unidade_id])
    @classe.classe_classe = session[:classe]
    t=0
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
                @nota.faltas1 = 0
                @nota.nota2 = nil
                @nota.faltas2 = 0
                @nota.nota3 = nil
                @nota.faltas3 = 0
                @nota.nota4 = nil
                @nota.faltas4 = 0
                @nota.nota5 = nil
                @nota.faltas5= 0
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
        @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0], :order =>'disciplinas.ordem ASC ' )
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
t=0
        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end


def consulta_classe_fone1

       session[:classe_id]=params[:classe][:id]

       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0], :order =>'disciplinas.ordem ASC ' )
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')

        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe_fone'
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
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0], :order =>'disciplinas.ordem ASC ' )
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe_editar'
       end
end

def renumera
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0], :order =>'disciplinas.ordem ASC ' )
       #@matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',  session[:classe_id]], :order => ' alunos.aluno_nome ASC')
       @matriculas = Matricula.find(:all,:joins => 'INNER JOIN alunos ON matriculas.aluno_id= alunos.id' ,:conditions =>['classe_id = ?',  session[:classe_id]],:readonly => false, :order => 'alunos.aluno_nome ASC' )
       
       session[:num]=1
       for matricula in @matriculas
           #status = status.matricula.status
           matricula.classe_num= session[:num]
          # status.matricula.status = status
           matricula.save
           session[:num]=session[:num]+1
       end
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
         @notas_inicial = Nota.find(:all, :conditions=>['aluno_id =? and unidade_id =? and ano_letivo =?', matricula.aluno_id, matricula.unidade_id, Time.now.year])
          session[:matricula_aluno_id] = matricula.aluno_id
          for atribuicao in @atribuicao_classe
               @notas_atribuicao_classe = Nota.find(:all,:conditions =>['aluno_id = ? AND ano_letivo=? AND disciplina_id=? and atribuicao_id=?', matricula.aluno_id,Time.now.year, atribuicao.disciplina_id, atribuicao.id])
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
#                                      else #                   if !@notas_matricula.empty?
 #                      w=@notas_matricula[0].id
 #                      w1= notas_matricula=@notas_matricula[0].id
#
  #                  end
#                  if !@notas_teste[0].unidade_id == notas.unidade_id

                                         @nota.nota5 = nil
#                                      end
                                      @nota.faltas5 = 0
                                      @nota.aulas5 = 0
                                        if @nota.save
                                          session[:created]=@nota.created_at
                                           flash[:notice] = 'NOTAS CRIADAS COM SUCESSO!'
                                        end
                                 end
                   
               end
          end



       end
  end


def nucleo_basico

       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0], :order => 'disciplina_id ASC')

       for matricula in @matriculas
          @nota_port = Nota.find(:all, :conditions =>['matricula_id =? AND disciplina_id = 1', matricula.id] )
          @atribuicao_s_port=Atribuicao.find(:all,:conditions =>['classe_id = ? AND ativo=? AND professor_id =? AND disciplina_id != 1', session[:classe_id],0,@nota_port[0].professor_id])
          for atribuicao in @atribuicao_s_port
              @nota = Nota.find(:all, :conditions => ['atribuicao_id =? AND matricula_id=?', atribuicao.id, matricula.id])
              @acerto = Nota.find(@nota[0].id)
              @acerto.faltas1=@nota_port[0].faltas1
              @acerto.aulas1=@nota_port[0].aulas1
              @acerto.freq1=@nota_port[0].freq1
              @acerto.faltas2=@nota_port[0].faltas2
              @acerto.aulas2=@nota_port[0].aulas2
              @acerto.freq2=@nota_port[0].freq2
              @acerto.faltas3=@nota_port[0].faltas3
              @acerto.aulas3=@nota_port[0].aulas3
              @acerto.freq3=@nota_port[0].freq3
              @acerto.faltas4=@nota_port[0].faltas4
              @acerto.aulas4=@nota_port[0].aulas4
              @acerto.freq4=@nota_port[0].freq4
              @acerto.faltas5=@nota_port[0].faltas5
              @acerto.aulas5=@nota_port[0].aulas5
              @acerto.freq5=@nota_port[0].freq5
                if @acerto.save
                  flash[:notice] = 'NOTAS ACERTADAS COM SUCESSO!'
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
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0], :order =>'disciplinas.ordem ASC ' )
       t1=session[:classe_id]

       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?',  session[:classe_id]], :order => 'classe_num ASC')
      render :layout => "impressao"
end

def impressao_classe_fone
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0], :order =>'disciplinas.ordem ASC ' )
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

def impressao_lista_responsavel
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0], :order =>'disciplinas.ordem ASC ' )
       t1=session[:classe_id]

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

    if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ?' , params[:ano_letivo] ], :order => 'classes.classe_classe ASC')
        #@classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id]    )
    else
       @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id]    )
    end




   render :partial => 'selecao_classe'
  end



 def load_classes
   @ano =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo ASC')
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        #@classe = Classe.find(:all, :order => 'classe_classe ASC')
        @classe = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ? AND classes.sala !=52', Time.now.year  ], :order => 'classes.classe_classe ASC')
        #@classe_todas =  Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        #@classe_todas =  Classe.find(:all, :conditions => ['unidade_id = ? ', current_user.unidade_id  ], :order => 'classe_ano_letivo ASC, classe_classe ASC')
        @classe_td =  Classe.find(:all,:select => 'distinct(classe_ano_letivo)',:order => 'classe_ano_letivo ASC')

    end
 end

def lista_responsavel
 
end


def lista_responsavel_aluno
       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')

        render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_lista_responsavel'
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
