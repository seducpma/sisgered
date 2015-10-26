class CriancasController < ApplicationController

  before_filter :load_unidades
  before_filter :load_grupos
  before_filter :load_regiaos
  before_filter :load_unidades
  before_filter :load_criancas
  before_filter :load_criancas_mat
  require_role ["seduc","admin","escola"], :for => :update # don't allow contractors to update
  require_role ["seduc","admin"], :for => :destroy # don't allow contractors to destroy
  require_role ["seduc"], :for => [:atualiza_grupo,:matric,:config,:confirma] #



# GET /criancas
  # GET /criancas.xml
  def index
    @criancas = Crianca.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @criancas }
    end
  end

  def relatorio_crianca
    @crianca = "Filtre pela criança desejada"
  end

  def search
    @crianca = Crianca.find(:all, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"], :include => ['grupo','unidade'])
    render :action => 'relatorio_crianca'
  end


  # GET /criancas/1
  # GET /criancas/1.xml
  def show
     @crianca = Crianca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crianca }
    end
  end

  # GET /criancas/new
  # GET /criancas/new.xml
  def new
    @crianca = Crianca.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crianca }
    end
  end

  # GET /criancas/1/edit
  def edit

    @crianca = Crianca.find(params[:id])
    $status = @crianca.status
    #@unidade_matricula = Unidade.find_by_sql("select u.id, u.nome from unidades u right join criancas c on u.id in (c.option1, c.option2, c.option3, c.option4) where c.id = " + (@crianca.id).to_s)
    $id_crianca = params[:id]
    $nome = params[:nome]
  end

  # POST /criancas
  # POST /criancas.xml
  def create
    @crianca = Crianca.new(params[:crianca])
  $flag_imp = 0
  $flag_btimp = 0

    respond_to do |format|
      if @crianca.save
        flash[:notice] = 'Criança cadastrada com sucesso.'
        format.html { redirect_to(@crianca) }
        format.xml  { render :xml => @crianca, :status => :created, :location => @crianca }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @crianca.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /criancas/1
  # PUT /criancas/1.xml
  def update
    @crianca = Crianca.find(params[:id])
    #@atualiza_log = Log.new
    #@atualiza_log.user_id = current_user.id
    #@atualiza_log.obs = "Atualizado"
    #@atualiza_log.data = (Time.now().strftime("%d/%m/%y %H:%M")).to_s
    #@atualiza_log.crianca_id = @crianca.id
    #@atualiza_log.save

    respond_to do |format|
      if @crianca.update_attributes(params[:crianca])
        flash[:notice] = 'Criança atualizada com sucesso.'
        format.html { redirect_to(@crianca) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crianca.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /criancas/1
  # DELETE /criancas/1.xml
  def destroy
    @crianca = Crianca.find(params[:id])
    @crianca_log = Log.new
    @crianca_log.user_id = current_user.id
    @crianca_log.obs = "Apagado"
    @crianca_log.data = (Time.now().strftime("%d/%m/%y %H:%M")).to_s
    @crianca_log.crianca_id = @crianca.id
    @crianca_log.save
    @crianca.destroy

    respond_to do |format|
      format.html { redirect_to(criancas_url) }
      format.xml  { head :ok }
    end
  end

  def autentica_matricula
    $unidade_matricula = params[:crianca_unidade_matricula]
    #@teste = Crianca.find(params[:id])
    @existe = Crianca.find(:all, :conditions => ["((id= "+ $id_crianca +" and (opcao1 = " + $unidade_matricula + " or opcao2 = " + $unidade_matricula + " or opcao3 = " + $unidade_matricula + " or opcao4 = " + $unidade_matricula +")))"])
    if @existe.empty? then
     render :update do |page|
      page.replace_html 'unidade', :text => "OPÇÃO NÃO ESCOLHIDA NO CADASTRO DE PREFERÊNCIA DE UNIDADE. ESCOLHA UMA DAS OPÇÕES LISTADA ACIMA."
      page.replace_html 'Certeza', :text =>  'PREFERÊNCIA DE MATRÍCULA INVÁLIDA, FAVOR REFAZER A OPÇÂO DE MATRÍCULA.'
     end


    else
      render :update do |page|
        page.replace_html 'unidade', :text => "OPÇÃO PREVISTA DURANTE O CADASTRO DA CRIANÇA NAS PREFERÊNCIA DE UNIDADE"
        page.replace_html 'Certeza', :text => "<input id='crianca_submit' name='commit' type='submit' value='Atualizar' />"
      end
    end
  end

 
  def consultacrianca

     if params[:type_of].to_i == 1
        @criancas = Crianca.find(:all,:conditions => ["nome like ? and  status = 'NA_DEMANDA'", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
        render :update do |page|
          page.replace_html 'criancas', :partial => "criancas"
        end
     else if params[:type_of].to_i == 2
              if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                 @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'"],:order => 'nome ASC, unidade_id ASC')
              else
                 @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' and unidade_id = ?", current_user.unidade_id ],:order => 'nome ASC')
              end
             render :update do |page|
                page.replace_html 'criancas', :partial => "criancas"
              end
         else if params[:type_of].to_i == 6
                @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'" ],:order => 'nome ASC')
                render :update do |page|
                   page.replace_html 'criancas', :partial => "criancas"
               end
          end
     end

  end
  end


 def consulta_geral
      @criancas = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'" ],:order => "trabalho DESC, servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 end



def consulta_unidade
  
     
 end

def classificao_unidade
  
  session[:opcao]=Unidade.find_by_id(params[:crianca_unidade_id]).nome
  
 @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao1=? ",  session[:opcao] ],:order => "servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao2=? ",  session[:opcao] ],:order => "servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=? ",  session[:opcao] ],:order => "servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao1=? ",  session[:opcao] ],:order => "servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao2=? ",  session[:opcao] ],:order => "servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao3=? ",  session[:opcao] ],:order => "servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")

 #@criancas1 = Crianca.find( :all,:conditions => ["status ='NA_DEMANDA' and opcao1=?",session[:opcao] ],:order => " trabalho DESC, servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC, opcao1")
 #@criancas1 = @criancas1.sort_by{|e| -e.trabalho}
 #@criancas1 = @criancas1.sort_by{|e| -e.servidor_publico}
 #@criancas1 = @criancas1.sort_by{|e| -e.irmao}
 #@criancas1 = @criancas1.sort_by{|e| -e.transferencia}


 @criancas = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6
# @criancas = @criancas.sort_by{|e| -e.trabalho}
# @criancas = @criancas.sort_by{|e| -e.servidor_publico}
# @criancas = @criancas.sort_by{|e| -e.irmao}
# @criancas = @criancas.sort_by{|e| -e.transferencia}



                

  render :partial => 'criancas_unidade'
  
  
end





  def nome_crianca
    $consulta = 6
    $crianca = params[:crianca_crianca_id]
    @crianca = Crianca.find(:all, :conditions => ['id=' + $crianca ])
    render :partial => 'listar_todas_criancas'
  end


  def regiao_unidade
    @unidades = Unidade.find :all, :conditions => {:regiao_id => params[:cr_id]}
    render :update do |page|
    page.replace_html 'regiao', :partial => 'regiao_unidade'
    end
  end




  def consulta
    render :partial => 'consultas'
  end

 def matric
    render :partial => 'matricular'
  end


  def mesmo_nome
    $nome = params[:crianca_nome]
    @verifica = Crianca.find_by_nome($nome)
    if @verifica then
      render :update do |page|
        page.replace_html 'nome_aviso', :text => 'Nome já cadastrado no sistema'
        page.replace_html 'aviso_mae', :text => 'Mae:' +  @verifica.mae
        
    end
    else
      render :update do |page|
        page.replace_html 'nome_aviso', :text => ''
        page.replace_html 'aviso_mae', :text => ''
      end

    end
  end

  def mesma_mae
     if Crianca.find_by_mae(params[:crianca_mae]) then
       if Crianca.find_by_nome($nome) then
        render :update do |page|
          page.replace_html 'nome_mae', :text => 'Criança já cadastrada no sistema '
          page.replace_html 'Certeza', :text =>  'Criança ja cadastrada'
        end
        else
          render :update do |page|
             page.replace_html 'nome_mae', :text => ''
             page.replace_html 'Certeza', :text => "<input id='crianca_submit' name='commit' type='submit' value='Cadastrar' />"
          end

       end
     else
       render :nothing => true
     end
  end


 def impressao
       @crianca = Crianca.find(:all,:conditions => ["id = ?",   session[:child]])
      render :layout => "impressao"
end


 def impressao_class_unidade
  

 @criancas1 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao1=? ",  session[:opcao] ],:order => " servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas2 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao2=? ",  session[:opcao] ],:order => " servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas3 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 1 and opcao3=? ",  session[:opcao] ],:order => " servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas4 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao1=? ",  session[:opcao] ],:order => " servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas5 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao2=? ",  session[:opcao] ],:order => " servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 @criancas6 = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA' AND trabalho = 0 and opcao3=? ",  session[:opcao] ],:order => " servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC")
 
 #@criancas1 = Crianca.find( :all,:conditions => ["status ='NA_DEMANDA' and opcao1=?",session[:opcao] ],:order => " trabalho DESC, servidor_publico DESC, irmao DESC, transferencia DESC, created_at ASC, opcao1")
 #@criancas1 = @criancas1.sort_by{|e| -e.trabalho}
 #@criancas1 = @criancas1.sort_by{|e| -e.servidor_publico}
 #@criancas1 = @criancas1.sort_by{|e| -e.irmao}
 #@criancas1 = @criancas1.sort_by{|e| -e.transferencia}


 @criancas = @criancas1 + @criancas2 + @criancas3 + @criancas4 + @criancas5 + @criancas6

 render :layout => "impressao"
 end

  def same_birthday
    data_nasc = params[:ano].to_s + '-' + params[:mes].to_s + '-' + params[:dia].to_s
    if !Crianca.by_nome(params[:nome]).by_nascimento(data_nasc).empty? then
      render :text => 'Mesma data e mesmo nome'
    else
      render :text => 'Nenhuma data igual...'
    end
  end

 def verifica_data
   if not params[:crianca_nascimento_3i].nil? then
     ano = params[:crianca_nascimento_3i].to_s
   end
   if not params[:crianca_nascimento_1i].nil? then
     dia = params[:crianca_nascimento_1i].to_s
   end
   if not params[:crianca_nascimento_2i].nil? then
     mes = params[:crianca_nascimento_2i].to_s
   end
   data = dia.to_s + " " + mes.to_s + " " + ano.to_s
   render :text => data.to_s

 end



 protected
    #Inicialização variavel / combobox grupo

  def load_grupos
    @grupos =  Grupo.find(:all, :order => "nome")
  end

  def load_regiaos
    @regiaos =  Regiao.find(:all, :order => "nome")
  end

  def load_unidades
    $unidade = current_user.unidade_id
    if current_user.unidade_id== 53 or current_user.unidade_id==52
       @unidades1 =  Unidade.find(:all,  :conditions => ["tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8" ],:order => "nome")
       @unidades =  Unidade.find(:all,  :conditions => ["tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8" ],:order => "nome")
    else
       @unidades1 =  Unidade.find(:all,  :conditions => ["(tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8) and id=?", $unidade  ],:order => "nome")
       @unidades =  Unidade.find(:all,  :conditions => ["tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8" ],:order => "nome")
    end

    
  end

    


  def load_criancas
    @criancas = Crianca.find(:all, :order => "nome ASC")
  end

  def load_criancas_mat
#    @criancasmat = Crianca.find(:all, :conditions => ["matricula = 0" ], :order => "nome ASC")
  end



end


