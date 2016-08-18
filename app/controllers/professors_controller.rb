class ProfessorsController < ApplicationController
  
     before_filter :load_unidades
     before_filter :load_professors
     before_filter :load_classes

   def load_classes
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classes = Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
    end
 end

  def load_unidades
      @unidades = Unidade.find(:all, :order => 'nome ASC')
  end

  def load_professors
    if (current_user.unidade_id == 53 or current_user.unidade_id == 52 ) then
      @professors = Professor.find(:all, :conditions => 'desligado = 0 AND diversas_unidades =1' , :order => 'nome ASC')
      @professors1 = Professor.find(:all,:conditions => 'desligado = 0 AND diversas_unidades =1', :order => 'matricula ASC')
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
           @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
           @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join classes  on atribuicaos.classe_id = classes.id ", :conditions =>["classes.horario =? and classes.unidade_id =? ", params[:search], current_user.unidade_id])
               render :update do |page|
                  page.replace_html 'classe_professors', :partial => 'professors_classe1'
               end
         else if params[:type_of].to_i == 3
             t=0
                @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
                @atribuicao_classe = Atribuicao.find(:all, :joins => "inner join professors  on atribuicaos.professor_id = professors.id ", :conditions =>["professors.id =? ", params[:professor][:id]])
                  render :update do |page|
                    page.replace_html 'classe_professors', :partial => 'professors_classe1'
                     end
              end
         end
    end
end


end
