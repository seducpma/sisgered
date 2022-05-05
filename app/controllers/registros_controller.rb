class RegistrosController < ApplicationController
  # GET /registros
  # GET /registros.xml

before_filter :load_dados_iniciais
   def load_dados_iniciais
     session[:cont_usuario_user_id]= current_user.unidade_id
     session[:cont_professor_user_id]= current_user.professor_id
       if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao')or current_user.has_role?('pedagogo')
         if current_user.has_role?('pedagogo')
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO"  )'],:order => 'nome ASC')
         else
            @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND ( classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
         end
            @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
            @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
            @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 2 or tipo_id = 3 or tipo_id = 4 or  tipo_id = 5  or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')

       else if current_user.has_role?('professor_infantil')
             @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
             @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ?' , Time.now.year,current_user.professor_id ], :order => 'classes.classe_classe ASC')
             @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 2 or  tipo_id = 5  or tipo_id = 8)'  ], :order => 'nome ASC')
              else if  current_user.has_role?('direcao_infantil')   or    current_user.has_role?('secretaria_infantil') or    current_user.has_role?('pedagogo')
                  @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ', :conditions => ['desligado = 0 AND (funcao2="PEDAGOGO" OR funcao2="PROF. COORDENADOR" or funcao2="DIRETOR ED. BÁSICA"  or funcao2="DIRETOR INFANTIL")'],:order => 'nome ASC')
                   @professor_unidade = Professor.find(:all, :conditions => ['unidade_id = ?  AND desligado = 0', (current_user.unidade_id)],:order => 'nome ASC')
                   @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ? AND unidades.id = ?' , Time.now.year,current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                   @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 2 or  tipo_id = 5  or tipo_id = 8) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
                   else if current_user.has_role?('professor_fundamental')
                         @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
                         @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ? and classes.unidade_id = ?' , Time.now.year,current_user.professor_id, current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                         @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                         @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4  or tipo_id = 7) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')
                         else if  current_user.has_role?('direcao_fundamental')   or    current_user.has_role?('secretaria_fundamental') or    current_user.has_role?('pedagogo')
                               @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ', :joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO" OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')

                               @professor_unidade = Professor.find(:all, :conditions => ['(unidade_id = ?) OR 	diversas_unidades = 1 AND desligado = 0 ', (current_user.unidade_id)],:order => 'nome ASC')
                                @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ? AND unidades.id = ?' , Time.now.year,current_user.unidade_id ], :order => 'classes.classe_classe ASC')
                                @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
                              end

                          end
                    end
              end
       end
  end

   def aluno
     w=session[:cont_aluno_id]=params[:aluno_id]
     t=0
   end


 def classe
 w=session[:professor_id]=params[:registro_professor_id]
    @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
    if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
       if @atribuicao.count > 1
          session[:atribuicao]=@atribuicao[0].classe_id
          w=@atribuicao[0].id
           teste= @atribuicao[0].classe.classe_classe[0,3]
          if teste == 'AEE'
            w=session[:atribuicao]= 'AEE'
          end
           render :partial => 'disciplina'
       else
           session[:cont_atribuicao_id]=@atribuicao[0].id
   
           session[:cont_unidade_id]=@atribuicao[0].classe.unidade_id
           session[:cont_classe_id]= @atribuicao[0].classe_id
           @alunos= Aluno.find(:all, :joins => "INNER JOIN matriculas ON matriculas.aluno_id = alunos.id", :conditions => ["matriculas.classe_id =?  and ano_letivo=?", session[:cont_classe_id], Time.now.year ])
           render :partial => 'dados_classe'
       end
    end
 end



def lancamentos_registros
      w=  session[:disciplina] = params[:disciplina]
         
        if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
t=0
            for dis in @disci
                session[:disc_id] = dis.id
            end
            a= session[:classe_id] = params[:classe][:id]
            b= session[:professor_id]= params[:professor][:id]
            t=0
                t=0
              if session[:disciplina] == 'AEE'
                @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? ', params[:classe][:id], params[:professor][:id]])
                 @matriculas = AtendimentoAee.find(:all, :conditions=>['classe_id = ?', session[:classe_id]],:order => 'classe_num ASC' )
                @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? ', params[:classe][:id], params[:professor][:id]])
                for atrib in @atribuicao_classe
                   c= session[:atrib_id] = atrib.id
                end
              else
                @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
                @matriculas = Matricula.find(:all, :conditions=>['classe_id = ?', session[:classe_id]],:order => 'classe_num ASC' )
                @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
                for atrib in @atribuicao_classe
                   c= session[:atrib_id] = atrib.id
                end
              end


          
        end
        t=0
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @classes }
        end
       

end
def consulta_registros
   t=0
    if params[:type_of].to_i == 3  # Não existe esta opção
    else if params[:type_of].to_i == 1   # Não existe esta opção
        else  if params[:type_of].to_i == 2 # Aluno
              w= params[:aluno]
              if (current_user.has_role?('professor_infantil')  or current_user.has_role?('direcao_infantil') or current_user.has_role?('professor_fundamental')  or current_user.has_role?('direcao_fundamental') or current_user.has_role?('pedagogo')or current_user.has_role?('admin'))
                if (current_user.has_role?('professor_infantil')  or current_user.has_role?('professor_fundamental')  )
                 @registros=Registro.find(:all, :conditions=>  ["ano_letivo =? AND professor_id=? AND aluno_id=? ", Time.now.year, current_user.professor_id, params[:aluno]])
                else
                 @registros=Registro.find(:all, :conditions=>  ["ano_letivo =? AND unidade_id=? AND aluno_id=? ", Time.now.year, current_user.unidade, params[:aluno]])
                end
              end
             render :update do |page|
                 page.replace_html 'relatorio', :partial => 'conteudo'
             end

              else if params[:type_of].to_i == 4    #classe
                       w= params[:classe_id]
                       if (current_user.has_role?('professor_infantil')  or current_user.has_role?('direcao_infantil') or current_user.has_role?('professor_fundamental')  or current_user.has_role?('direcao_fundamental') or current_user.has_role?('pedagogo')or current_user.has_role?('admin'))
                        @registros=Registro.find(:all, :conditions=>  ["ano_letivo =? AND professor_id=? AND classe_id=? ", Time.now.year, current_user.professor_id, params[:classe_id]])
                       else
                        @registros=Registro.find(:all, :conditions=>  ["ano_letivo =? AND unidade_id=?  ", Time.now.year, current_user.unidade_id]) 
                       end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'conteudo'
                        end


                      end
             end
        end
    end

end

  def index
    @registros = Registro.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registros }
    end
  end

  # GET /registros/1
  # GET /registros/1.xml
  def show
    @registro = Registro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registro }
    end
  end

  # GET /registros/new
  # GET /registros/new.xml
  def new




     session[:aluno_id]=params[:aluno_id]
     w1=session[:disciplina]
     w2=session[:professor]
     w3=session[:professor_id]
     w4=session[:classe]
     w5=session[:classe_id]
     w6=session[:ano]
     w7=session[:periodo]
     w8=session[:id]
     
     @aluno= Aluno.find(:all, :conditions =>['id=?', session[:aluno_id]])
#     @registro= Registro.find(:all, :conditions =>['aluno_id=? and ano_letivo=?', session[:aluno_id], Time.new.year])
#      w=session[:registro_id]= @registro[0].id
#     if @registro.nil?
          w9=session[:aluno]= @aluno[0]. aluno_nome
          @registro = Registro.new

          respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @registro }
          end
#    else
#          @registro = Registro.find(session[:registro_id])
#     end
  end

  # GET /registros/1/edit
  def edit
    @registro = Registro.find(params[:id])
  end

  # POST /registros
  # POST /registros.xml
  def create
    @registro = Registro.new(params[:registro])
    @registro.inicio =Time.now
    @registro.fim =@registro.inicio
    #@registro.classe_id= session[:cont_classe_id]
    #@registro.atribuicao_id= session[:cont_atribuicao_id]
    #@registro.unidade_id= session[:cont_unidade_id]
    #@registro.ano_letivo = Time.now.year
    #@registro.aluno_id= session[:cont_aluno_id]
    t=0

     @registro.aluno_id = session[:aluno_id]
     @registro.ano_letivo = Time.now.year
     @registro.unidade_id= session[:unidade_id]
     @registro.disciplina_id=session[:disciplina_id]
     @registro.professor_id=session[:professor_id]
     @registro.classe_id=session[:classe_id]
    @registro.atribuicao_id= session[:atribuicao_id]

    respond_to do |format|
      if @registro.save
        flash[:notice] = 'REGISTRO INDIVIDUAL DE ALUNO CADASTRADO.'
        format.html { redirect_to(@registro) }
        format.xml  { render :xml => @registro, :status => :created, :location => @registro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registros/1
  # PUT /registros/1.xml
  def update
    @registro = Registro.find(params[:id])

    respond_to do |format|
      if @registro.update_attributes(params[:registro])
        flash[:notice] = 'REGISTRO INDIVIDUAL DE ALUNO CADASTRADO.'
        format.html { redirect_to(@registro) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registros/1
  # DELETE /registros/1.xml
  def destroy
    @registro = Registro.find(params[:id])
    @registro.destroy

    respond_to do |format|
      format.html { redirect_to(registros_url) }
      format.xml  { head :ok }
    end
  end
end
