class AtasController < ApplicationController
  # GET /atas
  # GET /atas.xml
before_filter :load_dados_iniciais
  def load_dados_iniciais
    @unidades = Unidade.find(:all,  :conditions => ['desativada = 0 '  ], :order => 'nome ASC')
  end

  def impressao
     @ata = Ata.find(:all, :conditions => ["id =?", params[:id]])

     render :layout => "impressao"

  end

  def index
    @atas = Ata.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @atas }
    end
  end

  # GET /atas/1
  # GET /atas/1.xml
  def show
    @ata = Ata.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ata }
    end
  end

  # GET /atas/new
  # GET /atas/new.xml
  def new
    @ata = Ata.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ata }
    end
  end

  # GET /atas/1/edit
  def edit
    @ata = Ata.find(params[:id])
  end

  # POST /atas
  # POST /atas.xml
  def create
    @ata = Ata.new(params[:ata])
    if params[:tipo_reuniao] != 'outros'
       @ata.titulo= params[:tipo_reuniao]
    end
    respond_to do |format|
      if @ata.save
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@ata) }
        format.xml  { render :xml => @ata, :status => :created, :location => @ata }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ata.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /atas/1
  # PUT /atas/1.xml
  def update
    @ata = Ata.find(params[:id])

    respond_to do |format|
      if @ata.update_attributes(params[:ata])
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@ata) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ata.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /atas/1
  # DELETE /atas/1.xml
  def destroy
    @ata = Ata.find(params[:id])
    @ata.destroy

    respond_to do |format|
      format.html { redirect_to(atas_url) }
      format.xml  { head :ok }
    end
  end



  def consulta_ata
        if params[:type_of].to_i == 1

        session[:dataI]=params[:ata][:inicio][6,4]+'-'+params[:ata][:inicio][3,2]+'-'+params[:ata][:inicio][0,2]
        session[:dataF]=params[:ata][:fim][6,4]+'-'+params[:ata][:fim][3,2]+'-'+params[:ata][:fim][0,2]
        session[:mes]=params[:ata][:fim][3,2]
        session[:anoI]=params[:ata][:inicio][6,4]
        session[:anoF]=params[:ata][:fim][6,4]
        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo') or current_user.has_role?('direcao_fundamental') or current_user.has_role?('direcao_infantil'))
             if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') )
                 @atas = Ata.find(:all, :conditions =>  ["data between ? and ? ", session[:dataI].to_s, session[:dataF].to_s], :order => 'data DESC')
             else  # ifcurrent_user.has_role?('direcao_fundamental') or current_user.has_role?('direcao_infantil')
                @atas = Ata.find(:all, :conditions =>  ["data between ? and ?  and unidade_id=? ", session[:dataI].to_s, session[:dataF].to_s, current_user.unidade_id], :order => 'data DESC')
             end
        else
            @atas = Ata.find(:all, :conditions =>  ["data between ? and ? and unidade_id =? ", session[:dataI].to_s, session[:dataF].to_s, current_user.unidade_id], :order => 'data DESC')
        end


        render :update do |page|
            page.replace_html 'atas', :partial => 'atas'
        end

        else if params[:type_of].to_i == 2
                    if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo') or current_user.has_role?('direcao_fundamental') or current_user.has_role?('direcao_infantil'))
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') )
                           @atas = Ata.find(:all, :conditions =>  ["titulo = ?  ",params[:titulo]], :order => 'data DESC')
                        else #   if ( current_user.has_role?('direcao_fundamental') or current_user.has_role?('direcao_infantil'))
                          @atas = Ata.find(:all, :conditions =>  ["titulo = ? and unidade_id =? ",params[:titulo], current_user.unidade_id], :order => 'data DESC')
                        end
                    else
                        @atas = Ata.find(:all, :conditions =>  ["titulo = ? and unidade_id =?",params[:titulo],current_user.unidade_id], :order => 'data DESC')
                    end
                  render :update do |page|
                      page.replace_html 'atas', :partial => 'atas'
                  end
             else if params[:type_of].to_i == 3
                       if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo') or current_user.has_role?('direcao_fundamental') or current_user.has_role?('direcao_infantil'))
                         if (current_user.has_role?('pedagogo')or current_user.has_role?('supervisao'))
                             @atas = Ata.find(:all, :conditions =>  ["unidade_id = ? and (titulo NOT like ?) and (titulo NOT like ?)  ",params[:unidade],'CONSELHO'+'%', 'DIRETORES'+'%'], :order => 'data DESC')
                          else 
                              @atas = Ata.find(:all, :conditions =>  ["unidade_id = ?  ",params[:unidade]], :order => 'data DESC')
                          end
                        else
                           @atas = Ata.find(:all, :conditions =>  ["unidade_id = ?  ",params[:unidade]], :order => 'data DESC')
                           #@atas = Ata.find(:all, :conditions =>  ["titulo = ? and unidade_id =?",params[:titulo],current_user.unidade_id], :order => 'data DESC')
                        end

                    
                    render :update do |page|
                        page.replace_html 'atas', :partial => 'atas'
                    end
                  end

             end

        end

  end

  def consulta_conteudo
    if params[:type_of].to_i == 3
            session[:cons_data]=0
             session[:cont_professor] =  params[:professor]
            if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
            else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                     x1=current_user.unidade_id
                    x2=current_user.professor_id
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                 else
                    @conteudos = Conteudo.find(:all, :conditions =>  ["professor_id =?  AND ano_letivo = ?", session[:cont_professor], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                    @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["professor_id=?  AND ano_letivo = ? ",session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                    @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["professor_id=?     AND ano_letivo = ?", session[:cont_professor], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                     end
            end
            render :update do |page|
                page.replace_html 'relatorio', :partial => 'conteudo'
            end

    else if params[:type_of].to_i == 1
        session[:cons_data]=1
        w=session[:tiporelatorio]=1
        #w1=session[:professor_id]=params[:conteudo][:professor_id]
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
        t=0

        #ATENÇÂO COM A DATA FINAL   VVVVVVVVVVVVV

        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
            @conteudos = Conteudo.find(:all, :conditions =>  ["inicio >=? AND (fim <=?)   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :order => 'inicio DESC, classe_id ASC')
            @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["inicio >=? AND fim <=?  AND ano_letivo = ? ", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
            @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=?   AND ano_letivo = ?", session[:dataI], session[:dataF], Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                current_user.unidade_id
                current_user.professor_id
                #@dataF = Conteudo.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND  (fim >=?  or fim <?) AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF],current_user.professor_id, Time.now.year] , :order => 'classe_id ASC')
                #session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
                #session[:dataFF]=@dataF.fim
                 #if session[:dataFF] < session[:dataF].to_date
                  #   @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND  (fim >=?  or fim <?) AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF],current_user.professor_id, Time.now.year] , :order => 'classe_id ASC')
                 #else
             @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND  fim <=? AND professor_id = ?  AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year] , :order => 'inicio DESC, classe_id ASC')
                 #end
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND professor_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.professor_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             else
                  @dataF = Conteudo.find(:last, :joins =>:classe, :conditions =>  ["inicio >=? AND (fim >=?  or fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
                  session[:dataF]=params[:conteudo][:fim][6,4]+'-'+params[:conteudo][:fim][3,2]+'-'+params[:conteudo][:fim][0,2]
       #           session[:dataFF]=@dataF.fim
       #            if session[:dataFF] < session[:dataF].to_date
       #                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND (fim >=?  or fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'classe_id ASC')
       #            else
               @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["inicio >=? AND fim <?) AND classes.unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],session[:dataF], current_user.unidade_id, Time.now.year] , :order => 'inicio DESC, classe_id ASC')

        #           end
                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["inicio >=? AND fim <=? AND unidade_id = ?  AND ano_letivo = ? ", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["inicio >=? AND fim <=? AND unidade_id = ?   AND ano_letivo = ?", session[:dataI], session[:dataF],current_user.unidade_id, Time.now.year], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
             end
        end
        render :update do |page|
            page.replace_html 'relatorio', :partial => 'conteudo'
        end
        else  if params[:type_of].to_i == 2
                        session[:cons_data]=0
                        w=session[:cont_unidade_id]=params[:unidade_cont]

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
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            @conteudos = Conteudo.find(:all, :joins =>:classe,  :conditions =>  ["classes.unidade_id = ? and classes.classe_ano_letivo =?", session[:cont_unidade_id], Time.now.year], :order => 'inicio DESC, classe_id ASC')
                            @conteudos_professor = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.professor_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ? and  classes.classe_ano_letivo=?", session[:cont_unidade_id], Time.now.year], :group => 'professor_id', :order => 'professors.nome ASC' )
                            @conteudos_classe = Conteudo.find(:all, :joins =>[:professor, :classe], :select => "conteudos.classe_id, count( conteudos.id ) as conta", :conditions =>  ["classes.unidade_id = ?", session[:cont_unidade_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                        else if (current_user.has_role?('professor_infantil') or current_user.has_role?('professor_fundamental'))
                               w1=current_user.unidade_id
                                w2=current_user.professor_id
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             else
                                @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ?", session[:cont_classe_id]] , :order => 'inicio DESC, classe_id ASC')
                                @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                             end
                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'conteudo'
                        end
              else if params[:type_of].to_i == 4
                       session[:disciplina_id]=params[:disciplina_id]
                        session[:cons_data]=0
                        session[:cont_classe_id]=params[:classe_id]
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
                        t=0
                        #session[:mostra_faltas_funcionario] = 1
                        #session[:mostra_faltas_professor] = 1
                        #session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
                        #if (session[:verifica_unidade_id]=='52')
                        t=session[:disciplina_id]
                        w=0
                        if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao') or current_user.has_role?('pedagogo'))
                            if session[:disciplina_id]=='--Todas--'
                              @conteudos = Conteudo.find(:all, :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :order => 'inicio DESC, classe_id ASC')
                              @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                              @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?", session[:cont_classe_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                            else
                              @conteudos = Conteudo.find(:all, :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :order => 'inicio DESC, classe_id ASC')
                              @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta, disciplina_id ",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                              @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ?  AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id],  current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                            end
                        else if (current_user.has_role?('professor_infantil')  or current_user.has_role?('direcao_infatil'))
                                w1=current_user.unidade_id
                                w2=current_user.professor_id
                                if session[:disciplina_id]=='--Todas--'
                                  @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id], current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                  @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )

                                else
                                       w1=session[:cont_classe_id]
                                       w2= session[:disciplina_id]
                                       w3= current_user.professor_id

                                  @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND professor_id=?", session[:cont_classe_id],  current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                  @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                  @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                                end

                            else if ( current_user.has_role?('professor_fundamental') or current_user.has_role?('direcao_fundamental')  )
                                w1=current_user.unidade_id
                                w2=current_user.professor_id
                                if session[:disciplina_id]=='--Todas--'
                                      @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=?  AND professor_id=?", session[:cont_classe_id], session[:disciplina_id],current_user.professor_id] , :order => 'inicio DESC, classe_id ASC')
                                      @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ?AND professor_id=?", session[:cont_classe_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                      t=0
                                 else if current_user.has_role?('professor_fundamental')
                                        @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=? AND professor_id=?", session[:cont_classe_id],session[:disciplina_id],  current_user.professor_id] , :order => 'classe_id ASC')
                                        @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ? AND professor_id=?", session[:cont_classe_id], session[:disciplina_id], current_user.professor_id], :group => 'professor_id', :order => 'classes.classe_classe ASC' )
                                       else
                                        @conteudos = Conteudo.find(:all, :joins =>:classe, :conditions =>  ["classe_id = ? AND disciplina_id=?", session[:cont_classe_id],session[:disciplina_id]] , :order => 'inicio DESC, classe_id ASC')
                                        @conteudos_professor = Conteudo.find(:all, :select => "conteudos.professor_id, count( conteudos.id ) as conta",:joins => "INNER JOIN professors ON conteudos.professor_id = professors.id", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'professors.nome ASC' )
                                        @conteudos_classe = Conteudo.find(:all, :select => "conteudos.classe_id, count( conteudos.id ) as conta",:joins => "INNER JOIN classes ON conteudos.classe_id = classes.id ", :conditions =>  ["classe_id = ? AND disciplina_id= ?", session[:cont_classe_id], session[:disciplina_id]], :group => 'professor_id', :order => 'classes.classe_classe ASC' )

                                      end
                                end

                             end

                         end
                        end
                        render :update do |page|
                            page.replace_html 'relatorio', :partial => 'conteudo'
                        end


                      end
             end
        end
    end

end
end
