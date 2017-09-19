class AulasFaltasController < ApplicationController
    # GET /aulas_faltas
    # GET /aulas_faltas.xml
    before_filter :load_iniciais


    def index
        @date = params[:month] ? Date.parse(params[:month]) : Date.today
        @date.strftime("%m")
        @search = AulasFalta.search(params[:search])
      
        if !(params[:search].blank?)
            @aulas_faltas = @search.all
            @aulas_faltas_unidade = @search.first
        end
        session[:search]=params[:search]
        if !(params[:search].blank?)
            params[:search][:unidade_id_equals]
            @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+@date.strftime("%m")+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(params[:search][:unidade_id_equals]).to_s+" AND professor_id IS NOT NULL ) GROUP BY professor_id")
            @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+@date.strftime("%m")+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(params[:search][:unidade_id_equals]).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
        end
        session[:funcionanrio] =1
        session[:professor] =1

    end

    def index2

        @date = params[:month] ? Date.parse(params[:month]) : Date.today
        @search = AulasFalta.search(params[:search])
        if !(params[:search].blank?)
            @aulas_faltas = @search.all
            @aulas_faltas_unidade = @search.first
        end
        session[:professor] =1
        session[:funcionario] =0

    end

    def index3

        @date = params[:month] ? Date.parse(params[:month]) : Date.today
        @search = AulasFalta.search(params[:search])
        if !(params[:search].blank?)
            @aulas_faltas = @search.all
            @aulas_faltas_unidade = @search.first
        end
        session[:funcionario] =1
        session[:professor] =0
    end


    # GET /aulas_faltas/1
    # GET /aulas_faltas/1.xml
    def show
        @aulas_falta = AulasFalta.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @aulas_falta }
        end
    end

    # GET /aulas_faltas/new
    # GET /aulas_faltas/new.xml
    def new
        @aulas_falta = AulasFalta.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @aulas_falta }
        end
    end

    # GET /aulas_faltas/1/edit
    def edit
        @aulas_falta = AulasFalta.find(params[:id])
    end

    # POST /aulas_faltas
    # POST /aulas_faltas.xml
    def create
        @aulas_falta = AulasFalta.new(params[:aulas_falta])
        @aulas_falta.ano_letivo =  Time.now.year
        respond_to do |format|
            if @aulas_falta.save
                flash[:notice] = 'AulasFalta was successfully created.'
                format.html { redirect_to(@aulas_falta) }
                format.xml  { render :xml => @aulas_falta, :status => :created, :location => @aulas_falta }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @aulas_falta.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /aulas_faltas/1
    # PUT /aulas_faltas/1.xml
    def update
        @aulas_falta = AulasFalta.find(params[:id])

        respond_to do |format|
            if @aulas_falta.update_attributes(params[:aulas_falta])
                flash[:notice] = 'AulasFalta was successfully updated.'
                format.html { redirect_to(@aulas_falta) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @aulas_falta.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /aulas_faltas/1
    # DELETE /aulas_faltas/1.xml
    def destroy
        @aulas_falta = AulasFalta.find(params[:id])
        @aulas_falta.destroy

        respond_to do |format|
            format.html { redirect_to(aulas_faltas_url) }
            format.xml  { head :ok }
        end
    end

    def data_falta
        session[:aulas_falta_data]=  params[:aulas_falta_data]

    end


    def nome_falta
        session[:aulas_falta_unidade_id]=params[:aulas_falta_unidade_id]
        @professores = Professor.find(:all, :conditions => ['unidade_id =? or unidade_id =? ', params[:aulas_falta_unidade_id], 54], :order => 'nome ASC')
        @funcionarios = Funcionario.find(:all, :conditions => ['unidade_id =? ', params[:aulas_falta_unidade_id]], :order => 'nome ASC')

        if (@professores.present?) or  (@funcionarios.present?)
            render :partial => 'selecao_falta'
        else
            render :partial => 'aviso'
        end
    end


    def relatorios_faltas
        session[:tiporelatorio]=1
        session[:mes_falta]=params[:mes]
        session[:verifica_unidade_id]=params[:aulas_falta][:unidade_id]
        if params[:mes] == '1'
            session[:mes] = 'JANEIRO'
        else if params[:mes] == '2'
                session[:mes] = 'FEVEREIRO'
            else if params[:mes] == '3'
                    session[:mes] = 'MARÇO'
                else if params[:mes] == '4'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '5'
                            session[:mes] = 'MAIO'
                        else if params[:mes] == '6'
                                session[:mes] = 'JUNHO'
                            else if params[:mes] == '7'
                                    session[:mes] = 'JULHO'
                                else if params[:mes] == '8'
                                        session[:mes] = 'AGOSTO'
                                    else if params[:mes] == '9'
                                            session[:mes] = 'SETEMBRO'
                                        else if params[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if params[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if params[:mes] == '12'
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
        session[:mostra_faltas_funcionario] = 1
        session[:mostra_faltas_professor] = 1

        session[:aulas_falta_unidade_id] = params[:aulas_falta][:unidade_id]
        if (session[:verifica_unidade_id]=='52')
            @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? ", params[:mes], Time.now.year], :order => 'data ASC')
            @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
            @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+"  AND funcionario_id IS NOT NULL) GROUP BY professor_id")
 #           @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+") GROUP BY tipo")
            @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+") GROUP BY tipo")
            session[:imprimemes] = 1
        else
            @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND unidade_id=?", params[:mes], Time.now.year, params[:aulas_falta][:unidade_id]], :order => 'data ASC')
            @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
            @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
#            @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+") GROUP BY tipo")
            @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+") GROUP BY tipo")
            @tipo_faltas_mes = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+") GROUP BY tipo")
            
            session[:imprimemes] = 1

        end
        render :update do |page|
            page.replace_html 'calendario', :partial => 'faltas'
        end
    end

    def relatorios_faltas_professor
        session[:tiporelatorio]=2
        session[:mes_falta]=params[:mes]
        session[:aulas_falta_professor_id]=params[:aulas_falta][:professor_id]
        session[:verifica_professor_id]=params[:aulas_falta][:professor_id]
        session[:mostra_falta_professor] = 1
        if params[:mes] == '1'
            session[:mes] = 'JANEIRO'
        else if params[:mes] == '2'
                session[:mes] = 'FEVEREIRO'
            else if params[:mes] == '3'
                    session[:mes] = 'MARÇO'
                else if params[:mes] == '4'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '5'
                            session[:mes] = 'MAIO'
                        else if params[:mes] == '6'
                                session[:mes] = 'JUNHO'
                            else if params[:mes] == '7'
                                    session[:mes] = 'JULHO'
                                else if params[:mes] == '8'
                                        session[:mes] = 'AGOSTO'
                                    else if params[:mes] == '9'
                                            session[:mes] = 'SETEMBRO'
                                        else if params[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if params[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if params[:mes] == '12'
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
        @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND professor_id=?", params[:mes], Time.now.year, params[:aulas_falta][:professor_id]], :order => 'data ASC')
        @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id ="+(session[:verifica_professor_id]).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
        @tipo_faltas_mes = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id ="+(session[:verifica_professor_id]).to_s+") GROUP BY tipo")
        @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+" AND professor_id ="+(session[:verifica_professor_id]).to_s+") GROUP BY tipo")
        session[:imprimeprofessor] = 1
        session[:mostra_faltas_professor] = 1

        render :update do |page|
            page.replace_html 'calendario', :partial => 'faltas'
        end
    end


    def relatorios_faltas_funcionario
        
        session[:tiporelatorio]=3
        session[:mes_falta]=params[:mes]
        session[:aulas_falta_funcinario_id]=params[:aulas_falta][:funcionario_id]
        session[:verifica_funcionario_id]=params[:aulas_falta][:funcionario_id]

        if params[:mes] == '1'
            session[:mes] = 'JANEIRO'
        else if params[:mes] == '2'
                session[:mes] = 'FEVEREIRO'
            else if params[:mes] == '3'
                    session[:mes] = 'MARÇO'
                else if params[:mes] == '4'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '5'
                            session[:mes] = 'MAIO'
                        else if params[:mes] == '6'
                                session[:mes] = 'JUNHO'
                            else if params[:mes] == '7'
                                    session[:mes] = 'JULHO'
                                else if params[:mes] == '8'
                                        session[:mes] = 'AGOSTO'
                                    else if params[:mes] == '9'
                                            session[:mes] = 'SETEMBRO'
                                        else if params[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if params[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if params[:mes] == '12'
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

        @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND funcionario_id=?", params[:mes], Time.now.year, params[:aulas_falta][:funcionario_id]], :order => 'data ASC')
        @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id ="+(session[:verifica_funcionario_id]).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
        @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id ="+(session[:verifica_funcionario_id]).to_s+") GROUP BY tipo")
        @tipo_faltas_mes = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id ="+(session[:verifica_funcionario_id]).to_s+") GROUP BY tipo")

        session[:imprimefuncionario] = 1
        session[:mostra_faltas_funcionario] = 1
        render :update do |page|
            page.replace_html 'calendario', :partial => 'faltas'
        end
    end




    def impressao_faltas
        if (session[:verifica_unidade_id]=='52')
            @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? ", session[:mes_falta], Time.now.year], :order => 'data ASC')
            @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
            @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+"  AND funcionario_id IS NOT NULL) GROUP BY professor_id")
#            @tipos_faltas_mes = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+") GROUP BY tipo")
#            @tipos_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+") GROUP BY tipo")

        else
            @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND unidade_id=?",session[:mes_falta], Time.now.year, session[:aulas_falta_unidade_id]], :order => 'data ASC')
            @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
            @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
            @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+") GROUP BY tipo")
            @tipo_faltas_mes = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+") GROUP BY tipo")
        end

        render :layout => "impressao"
    end

    def impressao_faltas_professor

        @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND professor_id=?",session[:mes_falta], Time.now.year, session[:aulas_falta_professor_id]], :order => 'data ASC')
        @faltas_professor = AulasFalta.find_by_sql("SELECT professor_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id ="+(session[:verifica_professor_id]).to_s+" AND professor_id IS NOT NULL) GROUP BY professor_id")
        #         @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id ="+(session[:verifica_professor_id]).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")
        @tipo_faltas_mes = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND professor_id ="+(session[:verifica_professor_id]).to_s+") GROUP BY tipo")
        @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+" AND professor_id ="+(session[:verifica_professor_id]).to_s+") GROUP BY tipo")


        render :layout => "impressao"
    end


    def impressao_faltas_funcionario
        w=session[:mes_falta]
        w1=session[:verifica_funcionario_id]
        t=0
        @aulas_faltas = AulasFalta.find(:all, :conditions =>  ["month(data)=? AND ano_letivo=? AND funcionario_id=?",session[:mes_falta], Time.now.year, session[:verifica_funcionario_id]], :order => 'data ASC')
        @tipo_faltas = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id ="+(session[:verifica_funcionario_id]).to_s+") GROUP BY tipo")
        @tipo_faltas_mes = AulasFalta.find_by_sql("SELECT tipo, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id ="+(session[:verifica_funcionario_id]).to_s+") GROUP BY tipo")
        @faltas_funcionario = AulasFalta.find_by_sql("SELECT funcionario_id, count( id ) as conta FROM aulas_faltas WHERE (month( data) = "+session[:mes_falta].to_s+" AND ano_letivo = "+(Time.now.year).to_s+" AND funcionario_id ="+(session[:verifica_funcionario_id]).to_s+" AND funcionario_id IS NOT NULL) GROUP BY professor_id")


        render :layout => "impressao"
    end


    def load_iniciais
        if current_user.has_role?('admin') or current_user.has_role?('SEDUC')
            @unidades_infantil = Unidade.find(:all,  :select => 'nome, id',:conditions =>  ["tipo_id = 2 OR tipo_id = 5 OR tipo_id = 8"], :order => 'nome ASC')
            @professores_faltas = Professor.find_by_sql("SELECT distinct(professors.id), professors.nome FROM professors INNER JOIN  aulas_faltas  ON  professors.id = aulas_faltas.professor_id  WHERE aulas_faltas.ano_letivo = "+(Time.now.year).to_s+" AND aulas_faltas.funcionario_id is null order by professors.nome ASC ")
            @funcionarios_faltas = Funcionario.find_by_sql("SELECT distinct(funcionarios.id), funcionarios.nome FROM funcionarios INNER JOIN  aulas_faltas  ON  funcionarios.id = aulas_faltas.funcionario_id  WHERE aulas_faltas.ano_letivo = "+(Time.now.year).to_s+" AND aulas_faltas.professor_id is null order by funcionarios.nome ASC ")
            #            @divisao=Professor.find(:all, :select=> 'nome, id', :conditions => 'id = 1')
            #            @divisao[0].nome="----------------------------------"
            #            @divisao[0].id = 0
            #            @pessoas = @professores_faltas + @divisao + @funcionarios_faltas

        else
            @unidades_infantil = Unidade.find(:all,  :select => 'nome, id', :conditions =>  ["id=?", current_user.unidade_id], :order => 'nome ASC')
            @professores_faltas = Professor.find_by_sql("SELECT distinct(professors.id), professors.nome FROM professors INNER JOIN  aulas_faltas  ON  professors.id = aulas_faltas.professor_id  WHERE aulas_faltas.ano_letivo = "+(Time.now.year).to_s+" AND aulas_faltas.unidade_id = "+(current_user.unidade_id).to_s+" AND aulas_faltas.funcionario_id is null order by professors.nome ASC ")
            @funcionarios_faltas = Funcionario.find_by_sql("SELECT distinct(funcionarios.id), funcionarios.nome FROM funcionarios INNER JOIN  aulas_faltas  ON  funcionarios.id = aulas_faltas.funcionario_id  WHERE aulas_faltas.ano_letivo = "+(Time.now.year).to_s+" AND aulas_faltas.unidade_id = "+(current_user.unidade_id).to_s+" AND aulas_faltas.professor_id is null order by funcionarios.nome ASC ")

        end


    end



end
