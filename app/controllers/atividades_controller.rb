class AtividadesController < ApplicationController
  # GET /atividades
  # GET /atividades.xml

 before_filter :load_dados_iniciais

  def load_dados_iniciais
    if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao')or current_user.has_role?('pedagogo')
          @pedagogos = Professor.find(:all, :select => 'distinct(professors.nome) as nome, professors.id as id ',:joins=> 'INNER JOIN atribuicaos ON atribuicaos.professor_id = professors.id INNER JOIN classes ON atribuicaos.classe_id = classes.id',:conditions => ['desligado = 0 AND (classes.classe_classe="PEDAGOGO" OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="SUPERVISÃO"  OR classes.classe_classe="COORDENAÇÃO" OR classes.classe_classe="DIREÇÃO FUNDAMENTAL" OR classes.classe_classe="DIREÇÃO INFANTIL")'],:order => 'nome ASC')
          @professor_unidade = Professor.find(:all, :conditions => ['desligado = 0'],:order => 'nome ASC')
          @classe_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_unidade", :conditions => ['classes.classe_ano_letivo = ?' , Time.now.year ], :order => 'classes.classe_classe ASC')
          @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or tipo_id = 2 or tipo_id = 3 or tipo_id = 4 or  tipo_id = 5  or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
    else
         @professor_unidade = Professor.find(:all, :conditions => ['id = ?  AND desligado = 0', (current_user.professor_id)],:order => 'nome ASC')
         @classe_ano = Classe.find(:all, :select  ,:select => "distinct(classes.id), (classe_classe)  as classe_unidade", :joins => "INNER JOIN  atribuicaos  ON  classes.id = atribuicaos.classe_id", :conditions => ['classes.classe_ano_letivo = ? AND atribuicaos.professor_id = ? and classes.unidade_id = ?' , Time.now.year,current_user.professor_id, current_user.unidade_id ], :order => 'classes.classe_classe ASC')
         #@unidades = Unidade.find(:all,  :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4 or tipo_id = 7 or tipo_id = 8)'  ], :order => 'nome ASC')
         @unidades = Unidade.find(:all, :joins => "INNER JOIN  users  ON  unidades.id = users.unidade_id", :select => 'distinct(unidades.id), nome' , :conditions => ['desativada = 0 and (tipo_id = 1 or  tipo_id = 4  or tipo_id = 7) and users.unidade_id=?', current_user.unidade_id  ], :order => 'nome ASC')

    end

  end


  def index
    @atividades = Atividade.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atividades }
    end
  end

  # GET /atividades/1
  # GET /atividades/1.xml
  def show
    @atividade = Atividade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @atividade }
    end
  end

  # GET /atividades/new
  # GET /atividades/new.xml
  def new
    @atividade = Atividade.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @atividade }
    end
  end

  # GET /atividades/1/edit
  def edit
    @atividade = Atividade.find(params[:id])
  end

  # POST /atividades
  # POST /atividades.xml
  def create

    @atividade = Atividade.new(params[:atividade])

    @atividade.classe_id= session[:ativ_classe_id]
    @atividade.atribuicao_id= session[:ativ_atribuicao_id]
    @atividade.disciplina_id =session[:ativ_disciplina_id]
    @atividade.ano_letivo =  Time.now.year
    @atividade.unidade_id =  current_user.unidade_id
    @atividade.user_id =  current_user.id
    respond_to do |format|
      if @atividade.save
        flash[:notice] = 'Atividade was successfully created.'
        format.html { redirect_to(@atividade) }
        format.xml  { render :xml => @atividade, :status => :created, :location => @atividade }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @atividade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /atividades/1
  # PUT /atividades/1.xml
  def update
    @atividade = Atividade.find(params[:id])

    respond_to do |format|
      if @atividade.update_attributes(params[:atividade])
        flash[:notice] = 'Atividade was successfully updated.'
        format.html { redirect_to(@atividade) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @atividade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /atividades/1
  # DELETE /atividades/1.xml
  def destroy
    @atividade = Atividade.find(params[:id])
    @atividade.destroy

    respond_to do |format|
      format.html { redirect_to(atividades_url) }
      format.xml  { head :ok }
    end
  end

  def classe

     w=session[:professor_id]=params[:atividade_professor_id]
     t=0
     @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=?", session[:professor_id], Time.now.year ])
   if @atribuicao.empty? or @atribuicao.nil?
      render :partial => 'aviso'
    else
       if @atribuicao.count > 1
           render :partial => 'disciplina'
       else
           session[:cont_atribuicao_id]=@atribuicao[0].id
           session[:cont_classe_id]= @atribuicao[0].classe_id
           render :partial => 'dados_classe'
       end
    end
  end

  def disciplina

 session[:ativ_disciplina_id] =  params[:disciplina_id]  # <<<<<< ATENÇÂO esta escrito disciplina_id mas é atribuicao_id <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 @atribuicao = Atribuicao.find(:all, :conditions => ["professor_id =? and ano_letivo=? and id =?", session[:professor_id], Time.now.year, params[:disciplina_id] ])
 session[:ativ_classe_id]= @atribuicao[0].classe_id
 session[:ativ_atribuicao_id]=@atribuicao[0].id
 session[:ativ_disciplina_id]=@atribuicao[0].disciplina_id
        render :partial => 'dados_classe'
end


  def consultaatividade

    if params[:type_of].to_i == 1
          
          @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and atividade like ?',Time.now.year, "%" + params[:search].to_s + "%"],:order => 'inicio DESC')
          
      render :update do |page|
         page.replace_html 'atividades', :partial => "atividades"
      end
    else if params[:type_of].to_i == 2
               @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and classe_id=? and disciplina_id=?',Time.now.year, session[:classe_id],params[:disciplina_id]],:order => 'inicio DESC')
            render :update do |page|
               page.replace_html 'atividades', :partial => "atividades"
             end
       else if params[:type_of].to_i == 3
                    @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and professor_id=? ',Time.now.year,  params[:professor][:id]],:order => 'inicio DESC')
               render :update do |page|
                  page.replace_html 'atividades', :partial => "atividades"
               end
            else if params[:type_of].to_i == 4
                          @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and unidade_id=? ',Time.now.year,  params[:unidade][:id]],:order => 'inicio DESC')
                     render :update do |page|
                         page.replace_html 'atividades', :partial => "atividades"
                     end
                 else if params[:type_of].to_i == 5
                           @atividades = Atividade.find(:all,   :conditions =>['ano_letivo=? and disciplina_id=? ',Time.now.year,  params[:disciplina][:id]],:order => 'inicio DESC')
                         render :update do |page|
                          page.replace_html 'atividades', :partial => "atividades"
                          end
                      else if params[:type_of].to_i == 6

             session[:dia_final]=params[:diaF]
        session[:mesF]=params[:mesF]
        session[:dataI]=params[:conteudo][:inicio][6,4]+'-'+params[:conteudo][:inicio][3,2]+'-'+params[:conteudo][:inicio][0,2]
        session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
        session[:mes]=params[:conteudo][:fim][3,2]
        session[:anoI]=params[:conteudo][:inicio][6,4]
        session[:anoF]=params[:conteudo][:fim][6,4]
       if session[:mes] == '01'
            session[:mes] = 'JANEIRO'
        else if session[:mes] == '02'
                session[:mes] = 'FEVEREIRO'
            else if session[:mes] == '03'
                    session[:mes] = 'MARÇO'
                else if session[:mes] == '04'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '05'
                            session[:mes] = 'MAIO'
                        else if session[:mes] == '06'
                                session[:mes] = 'JUNHO'
                            else if session[:mes] == '07'
                                    session[:mes] = 'JULHO'
                                else if session[:mes] == '08'
                                        session[:mes] = 'AGOSTO'
                                    else if session[:mes] == '09'
                                            session[:mes] = 'SETEMBRO'
                                        else if session[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if session[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if session[:mes] == '12'
                                                        session[:mes] = 'DEZEMBRO'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end





                                if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                                   @atividades = Atividade.find(:all,  :joins => "INNER JOIN  professors   ON  professors.id = atividades.professor_id ", :conditions =>  ["atividades.inicio >=? AND atividades.fim <=?   AND atividades.ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year],  :order => 'professors.nome ASC' )
                                else 
                          #              @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                                end
                         
                                   @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado = 0", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
                               render :update do |page|
                                     page.replace_html 'atividades', :partial => "atividades"
                               end
                             end
                      end
                 end

            end
       end
    end

end

def consultas
end


    def classe_disciplina
    session[:classe_id]=params[:classe_id]
       @disciplina_classe = Disciplina.find(:all,:select => 'distinct(disciplinas.disciplina), disciplinas.id' ,:joins=> "INNER JOIN atribuicaos ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN atividades ON disciplinas.id = atividades.disciplina_id", :conditions=> ['atribuicaos.classe_id =? and atividades.classe_id=?', params[:classe_id], session[:classe_id]])
   render :partial => 'disciplina_classe'
  end
end
