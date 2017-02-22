class ProfessorsController < ApplicationController
  
     before_filter :load_unidades
     before_filter :load_professors
     before_filter :load_classes

   def load_classes
     @ano =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo ASC')
     @disciplinas = Disciplina.find(:all, :select => 'id, disciplina', :conditions => ["curriculo = 'B' OR curriculo = 'D'"], :order => 'disciplina ASC')
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classes = Classe.find(:all, :order => 'classe_classe ASC')
        @classes_todas = Classe.find(:all, :order => 'classe_ano_letivo ASC, classe_classe ASC')
        
    else
        @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        @classes_todas = Classe.find(:all, :conditions => ['unidade_id = ?  ', current_user.unidade_id  ], :order => 'classe_ano_letivo ASC, classe_classe ASC')

    end
 end

  def load_unidades
      @unidades = Unidade.find(:all, :order => 'nome ASC')
  end

  def load_professors
    if (current_user.unidade_id == 53 or current_user.unidade_id == 52 ) then
      @professors = Professor.find(:all, :conditions => 'desligado = 0' , :order => 'nome ASC')
      @professors1 = Professor.find(:all,:conditions => 'desligado = 0', :order => 'matricula ASC')
      
    else
      @professors = Professor.find(:all, :conditions => ['desligado = 0 AND (diversas_unidades =1 OR	unidade_id=?)',current_user.unidade_id ], :order => 'nome ASC')
      @professors1 = Professor.find(:all,:conditions => ['desligado = 0 AND (diversas_unidades =1 OR	unidade_id=?)',current_user.unidade_id ] , :order => 'matricula ASC')
    end

  end


  def index
    @professors = Professor.find(:all, :conditions => 'desligado = 0', :order => 'nome ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @professors }
    end
  end

  def show
    @professor = Professor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @professor }
    end
  end

  # GET /professors/new
  # GET /professors/new.xml
  def new
    @professor = Professor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @professor }
    end
  end

  
  def edit
    @professor = Professor.find(params[:id])
  end

  def create
    @professor = Professor.new(params[:professor])

    respond_to do |format|
      if @professor.save
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@professor) }
        format.xml  { render :xml => @professor, :status => :created, :location => @professor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @professor = Professor.find(params[:id])

    respond_to do |format|
      if @professor.update_attributes(params[:professor])
        flash[:notice] = 'SALVO COM SUCESSO!'
        format.html { redirect_to(@professor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @professor = Professor.find(params[:id])
    @professor.destroy

    respond_to do |format|
      format.html { redirect_to(professors_url) }
      format.xml  { head :ok }
    end
  end

  def consultaprofessor
    if params[:type_of].to_i == 3

          @professors = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
      render :update do |page|
         page.replace_html 'professores', :partial => "professores"
      end
    else if params[:type_of].to_i == 2
                @professors = Professor.find(:all, :conditions=> ["desligado = 0"],:order => 'nome ASC')
            render :update do |page|
               page.replace_html 'professores', :partial => "professores"
             end
       else if params[:type_of].to_i == 4
                    @professors = Professor.find(:all, :conditions=> ["desligado = 1"],:order => 'nome ASC')
               render :update do |page|
                  page.replace_html 'professores', :partial => "professores"
               end
            else if params[:type_of].to_i == 1

                         @professors = Professor.find(:all,:conditions => ["nome like ?", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
                     render :update do |page|
                          page.replace_html 'professores', :partial => "professores"
                     end
                 else if params[:type_of].to_i == 5
                         render :update do |page|
                           page.replace_html 'professores', :partial => "professores"
                          end
                      else if params[:type_of].to_i == 6

                                   @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado = 0", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
                               render :update do |page|
                                      page.replace_html 'professores', :partial => "professores"
                               end
                             end
                      end
                 end

            end
       end
    end

end

  def lista_professor_unidade
    $sede = params[:unidade_id]
    @professors = Professor.find(:all, :conditions => ['desligado =0 and unidade_id= ?', params[:unidade_id]])
    render :partial => 'professores'
  end

  def consulta_classe_professor
    if params[:type_of].to_i == 1
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
       render :update do |page|
          page.replace_html 'classe_professors', :partial => 'professors_classe'
       end
     else if params[:type_of].to_i == 2
         if current_user.unidade_id == 53 or current_user.unidade_id == 52
           @contador = Atribuicao.find(:all, :joins => "inner join classes  on atribuicaos.classe_id = classes.id inner join professors on atribuicaos.professor_id = professors.id", :select => 'distinct(atribuicaos.professor_id)',:conditions =>["classes.horario =?  AND classes.classe_ano_letivo =? AND atribuicaos.ano_letivo=? ", params[:search], Time.now.year, Time.now.year])
           @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join classes  on atribuicaos.classe_id = classes.id ", :conditions =>["classes.horario =?   AND atribuicaos.ano_letivo =?", params[:search],  Time.now.year])

         else
           @contador = Atribuicao.find(:all, :joins => "inner join classes  on atribuicaos.classe_id = classes.id inner join professors on atribuicaos.professor_id = professors.id", :select => 'distinct(atribuicaos.professor_id)',:conditions =>["classes.horario =? AND classes.unidade_id =? AND classes.classe_ano_letivo =? AND atribuicaos.ano_letivo=? ", params[:search], current_user.unidade_id, Time.now.year, Time.now.year])
           @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join classes  on atribuicaos.classe_id = classes.id ", :conditions =>["classes.horario =? and classes.unidade_id =?  AND atribuicaos.ano_letivo =?", params[:search], current_user.unidade_id,  Time.now.year])
         end
               render :update do |page|
                  page.replace_html 'classe_professors', :partial => 'professors_classe1'
               end
         else if params[:type_of].to_i == 3
                @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join professors  on atribuicaos.professor_id = professors.id ", :conditions =>["professors.id =? AND atribuicaos.ano_letivo =? ", params[:professor][:id], Time.now.year ])
                  render :update do |page|
                    page.replace_html 'classe_professors', :partial => 'professors_classe1'
                     end
              else if params[:type_of].to_i == 4
                       if current_user.unidade_id == 53 or current_user.unidade_id == 52
                          @contador= Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id  inner join professors  on atribuicaos.professor_id = professors.id ", :select => 'distinct(atribuicaos.professor_id)', :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=?", params[:disciplina][:id], Time.now.year])
                          @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id ", :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=?", params[:disciplina][:id], Time.now.year])
                            render :update do |page|
                              page.replace_html 'classe_professors', :partial => 'professors_classe1'
                          end
                       else
                          @contador= Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id  inner join professors  on atribuicaos.professor_id = professors.id inner join classes  on atribuicaos.classe_id = classes.id", :select => 'distinct(atribuicaos.professor_id)', :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=? AND classes.unidade_id =?", params[:disciplina][:id],  Time.now.year, current_user.unidade_id])
                          @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id  inner join classes  on atribuicaos.classe_id = classes.id ", :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=? AND classes.unidade_id =? " , params[:disciplina][:id],  Time.now.year, current_user.unidade_id])
                            render :update do |page|
                              page.replace_html 'classe_professors', :partial => 'professors_classe1'
                          end
                       end
                   end
              end
         end
    end
end

  def consulta_classe_anterior_professor
    if params[:type_of].to_i == 1
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
       render :update do |page|
          page.replace_html 'classe_professors', :partial => 'professors_classe'
       end
     else if params[:type_of].to_i == 2
           if current_user.unidade_id == 53 or current_user.unidade_id == 52
              @contador = Atribuicao.find(:all, :joins => "inner join classes  on atribuicaos.classe_id = classes.id inner join professors on atribuicaos.professor_id = professors.id",:conditions =>["classes.horario =? AND classes.unidade_id =? AND classes.classe_ano_letivo =? AND atribuicaos.ano_letivo=? ", params[:search], current_user.unidade_id, params[:search1], params[:search1]])
              @atribuicao_classe = Atribuicao.find(:all, :joins => "join classes  on atribuicaos.classe_id = classes.id ", :conditions =>["classes.horario =? and classes.unidade_id =? AND classes.classe_ano_letivo =? ", params[:search], current_user.unidade_id, params[:search1]])
           else
              @contador = Atribuicao.find(:all, :joins => "inner join classes  on atribuicaos.classe_id = classes.id inner join professors on atribuicaos.professor_id = professors.id", :select => 'distinct(atribuicaos.professor_id)',:conditions =>["classes.horario =? AND classes.unidade_id =? AND classes.classe_ano_letivo =? AND atribuicaos.ano_letivo=? ", params[:search], current_user.unidade_id, params[:search1], params[:search1]])
              @atribuicao_classe = Atribuicao.find(:all, :joins => "join classes  on atribuicaos.classe_id = classes.id ", :conditions =>["classes.horario =? and classes.unidade_id =? AND classes.classe_ano_letivo =? ", params[:search], current_user.unidade_id, params[:search1]])
           end
               render :update do |page|
                  page.replace_html 'classe_professors', :partial => 'professors_classe1'
               end
         else if params[:type_of].to_i == 3
                @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join professors  on atribuicaos.professor_id = professors.id ", :conditions =>["professors.id =? ", params[:professor][:id]])
                  render :update do |page|
                    page.replace_html 'classe_professors', :partial => 'professors_classe1'
                     end
              else if params[:type_of].to_i == 4
                       if current_user.unidade_id == 53 or current_user.unidade_id == 52
                          @contador= Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id  inner join professors  on atribuicaos.professor_id = professors.id ", :select => 'distinct(atribuicaos.professor_id)', :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=?", params[:disciplina][:id],  params[:ano_letivo]])
                          @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id ", :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=?", params[:disciplina][:id],  params[:ano_letivo]])
                            render :update do |page|
                              page.replace_html 'classe_professors', :partial => 'professors_classe1'
                          end
                       else
                          @contador= Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id  inner join professors  on atribuicaos.professor_id = professors.id inner join classes  on atribuicaos.classe_id = classes.id", :select => 'distinct(atribuicaos.professor_id)', :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=? AND classes.unidade_id =?", params[:disciplina][:id],  params[:ano_letivo], current_user.unidade_id])
                          @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join disciplinas  on atribuicaos.disciplina_id = disciplinas.id  inner join classes  on atribuicaos.classe_id = classes.id ", :conditions =>["atribuicaos.disciplina_id =? AND atribuicaos.ano_letivo=? AND classes.unidade_id =? " , params[:disciplina][:id],  params[:ano_letivo], current_user.unidade_id])
                            render :update do |page|
                              page.replace_html 'classe_professors', :partial => 'professors_classe1'
                          end
                       end
                   end
              end
         end
    end
end

  def classes_ano
   @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id]    )

   render :partial => 'selecao_classe'
  end

end
