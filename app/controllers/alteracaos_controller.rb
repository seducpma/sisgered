class AlteracaosController < ApplicationController

  #require_role ["admin","planejamento"], :except => ['relatorio_ficha']
  #before_filter :login_require

  layout :define_layout

  def define_layout
      current_user.layout
  end

  def index
  end
  
  def alterar_classe
    $nregistros = 0
    @criancas_alteracao = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'" ])
    for crianca in @criancas_alteracao
      anterior = crianca.grupo_id
       if (crianca.nascimento <= '2015-10-31'.to_date and crianca.nascimento >= '2015-02-01'.to_date)
           crianca.grupo_id = 1
       else if(crianca.nascimento <= '2015-01-31'.to_date and crianca.nascimento >= '2014-07-01'.to_date)
               crianca.grupo_id = 2
            else if(crianca.nascimento <= '2014-06-30'.to_date and crianca.nascimento >= '2013-07-01'.to_date)
                    crianca.grupo_id = 4
                 else if(crianca.nascimento <= '2013-06-30'.to_date and crianca.nascimento >= '2012-07-01'.to_date)
                         crianca.grupo_id = 5
                      else if(crianca.nascimento <= '2012-06-30'.to_date and crianca.nascimento >= '2011-07-01'.to_date)
                              crianca.grupo_id = 6
                           else if(crianca.nascimento <= '2011-06-30'.to_date and crianca.nascimento >= '2010-07-01'.to_date)
                                   crianca.grupo_id = 7

                                end
                           end
                        end
                   end
               end
           end
      atual = crianca.grupo_id
      crianca.save

      if anterior != atual
        $nregistros = $nregistros + 1
      end
  

    end
    t1=$nregistros
    t0 =1
      render :update do |page|
        page.replace_html 'confirma', :text => "ATUALIZAÇÃO CONCLUIDA"
        page.replace_html 'confirma1', :text => "Foram alterados " + ($nregistros.to_s) +" resgistros"
      end


  end


  def alterar
  end

  def arrumar_titulos
    @titulos = TituloProfessor.find(:all,:joins => :professor, :conditions => ["(titulo_id = 6 or titulo_id = 7 or titulo_id = 8) and ano_letivo = ? and professors.titulo_arrumado = 1",params[:ano]])
  end


  #Flag titulo_arrumado no BD indica se a atualização para remover os titulos anuais ja foi realizada
  #Tipo booleana
  # 0 - Significa que foi realizado
  # 1 - Significa que ainda deve ser realiza

  def efetiva_arrumar_titulos
    @count = 0
    unless (params[:ano].nil?)
      @id_professor = Professor.all
      for professor in @id_professor
        titulos_anuais = TituloProfessor.sum('pontuacao_titulo', :conditions => ["professor_id = " +(professor.id).to_s + " and (titulo_id = 6 or titulo_id = 7 or titulo_id = 8) and ano_letivo = ?",params[:ano]])
        @professor = Professor.find(professor.id)
        if @professor.titulo_arrumado == true
          @professor.total_titulacao= @professor.total_titulacao - titulos_anuais
          @professor.titulo_arrumado = 0
          @professor.pontuacao_final = @professor.total_titulacao + @professor.total_trabalhado
          @count = @count + 1
        end
        @professor.save
      end
    end
    render :partial => "success"
  end




  def ficha_automatica    
  end

  def efetivar_ficha_automatica
    @professor= Professor.all
    for ficha in @professor
      @log = Log.new
      @log.log(current_user.id, ficha.id, "Criado a ficha de pontuacao via ficha automática para : #{ficha.id} - #{ficha.nome}")
      @log.save!

      @existe = Trabalhado.find_all_by_professor_id(ficha.id, :conditions => ['ano_letivo = ?',$data])
      @possui_ficha = Ficha.find_by_professor_id(ficha.id,:conditions =>['ano_letivo = ?',$data])
      @contagem_finalizada = AcumTrab.find_all_by_professor_id(ficha.id, :conditions => ['status = 1'])

      if @contagem_finalizada.present?
        if !@possui_ficha.present?
          @fichas = Ficha.new
        else
          @fichas = @possui_ficha
        end
          if @existe.count == 2 then

              @fichas.professor_id = ficha.id
              @acum_trab_ficha = AcumTrab.find_by_professor_id(ficha.id)
              @fichas.acum_trab_id = @acum_trab_ficha.id
              @fichas.tot_acum_ant_trab = @acum_trab_ficha.tot_acum_ant_trab
              @fichas.tot_acum_ant_efet = @acum_trab_ficha.tot_acum_ant_efet
              @fichas.tot_acum_ant_rede = @acum_trab_ficha.tot_acum_ant_rede
              @fichas.tot_acum_ant_unid = @acum_trab_ficha.tot_acum_ant_unid
              @fichas.tot_acum_trab = @acum_trab_ficha.tot_acum_trab
              @fichas.tot_acum_efet = @acum_trab_ficha.tot_acum_efet
              @fichas.tot_acum_rede = @acum_trab_ficha.tot_acum_rede
              @fichas.tot_acum_unid = @acum_trab_ficha.tot_acum_unid
              @fichas.tot_geral_trab = @acum_trab_ficha.tot_geral_trab
              @fichas.tot_geral_efet = @acum_trab_ficha.tot_geral_efet
              @fichas.tot_geral_rede = @acum_trab_ficha.tot_geral_rede
              @fichas.tot_geral_unid = @acum_trab_ficha.tot_geral_unid
              @fichas.valor_trab = @acum_trab_ficha.valor_trab
              @fichas.valor_efet = @acum_trab_ficha.valor_efet
              @fichas.valor_rede = @acum_trab_ficha.valor_rede
              @fichas.valor_unid = @acum_trab_ficha.valor_unid
              @fichas.trabalhado_anterior_id = Trabalhado.find_by_professor_id(ficha.id, :conditions => ['ano_letivo = ? and ano = ?',$data, (($data.to_i) -1).to_s]).id
              @fichas.trabalhado_atual_id = Trabalhado.find_by_professor_id(ficha.id, :conditions => ['ano_letivo = ? and ano = ?',$data, $data]).id
              @fichas.total_geral = Professor.find(ficha.id).pontuacao_final
              @fichas.total_titulacao = Professor.find(ficha.id).total_titulacao
              @fichas.total_trabalhado = Professor.find(ficha.id).total_trabalhado
              @fichas.ano_letivo = $data
            @fichas.save
          end
        end
    end    
    @professor_com_ficha = Ficha.paginate(:all,:page=>params[:page],:per_page =>25,:conditions => ['ano_letivo = ?', $data])
    redirect_to(relatorio_ficha_path)

  end
  
  def relatorio_ficha
    @list_year = Ficha.ano
    unless params[:year].nil?
      #@verifica_existencia = Trabalhado.find_by_professor_id(@professor,:joins => "right join professors on trabalhados.professor_id=professors.id ", :conditions => ["ano_letivo = ? and created_at < '2010-01-01 00:00:00'", params[:year]])
      if params[:search].blank?
        if current_user.regiao_id == 53 or current_user.regiao_id == 52 then
          @professor_com_ficha = Ficha.paginate(:all,:joins => :professor,:page=>params[:page],:per_page =>25,:conditions => ['ano_letivo = ?', params[:year]])
        else
          @professor_com_ficha = Ficha.paginate(:all,:joins => :professor,:page=>params[:page],:per_page =>25,:conditions => ['ano_letivo = ? and (professors.sede_id = ? or professors.sede_id = 54)', params[:year], current_user.regiao_id])
        end
      else
        if current_user.regiao_id == 53 or current_user.regiao_id == 52 then
          @professor_com_ficha = Ficha.paginate(:all,:joins => :professor,:page=>params[:page],:per_page =>25,:conditions => ['ano_letivo = ? and professors.matricula = ?', params[:year],params[:search]])
        else
          @professor_com_ficha = Ficha.paginate(:all,:joins => :professor,:page=>params[:page],:per_page =>25,:conditions => ['ano_letivo = ? and (professors.sede_id = ? or professors.sede_id = 54)  and professors.matricula = ?', params[:year], current_user.regiao_id,params[:search]])
        end
      end

    end
  end

  def relatorio_ficha_year
  end

  def acertar_unidade
    #p_u_c => Professores com Unidade Correta
    #p_u_a => Professores com Unidade Antiga
    @arruma_unidade = Professor.find_by_sql("SELECT p_u_c.id, p_u_c.matricula, p_u_c.sede_id as 'ser_corrigida',p_u_c.sede_id_ant, p_u_a.sede_id as 'unidades_corretas' FROM `professors` p_u_c inner join professors2 p_u_a on p_u_c.matricula=p_u_a.matricula where p_u_c.sede_id <> p_u_a.sede_id order by p_u_c.id")

    @arruma_unidade.each do |a_u|
      @professor = Professor.find(a_u)
      @professor.id
      @professor.sede_id = a_u.unidades_corretas
      @professor.save
    end

  end


  protected


end

