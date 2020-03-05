class EstatisticasController < ApplicationController
  before_filter :load_unidades
  before_filter :load_classes
  def index

  end

  def estatisticaclasse
   if params[:ano_letivo] != '--Todos--'
     if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classeI_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8)' , params[:ano_letivo] ], :order => 'classes.classe_classe, unidades.nome  ASC')
        t=0
     else
       @classeI_ano = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :conditions=> ['classes.classe_ano_letivo =? and classes.unidade_id=? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8)' , params[:ano_letivo], current_user.unidade_id]    )
       t=0
     end
        if params[:type_of].to_i == 1
            t=0
                render :update do |page|
                    page.replace_html 'estatisticaclasse', :partial => 'estatistica_classe'
                  end
        else if params[:type_of].to_i == 2

            else if params[:type_of].to_i == 3
                else if params[:type_of].to_i == 4
                    else if params[:type_of].to_i == 5
                        else if params[:type_of].to_i == 6
                            end
                        end
                    end

                end
            end
        end
   end
  end

  def  classeestatistica
  session[:ano]=params[:ano_letivo]
  session[:unidade] = params[:unidade]
       
        if (params[:type_of].to_i == 1)
          session[:todos_infantil] = 1
          session[:todos_fundamental] = 0
          if params[:ano_letivo] != '--Todos--'
              @classes = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['unidades.desativada= 0 AND classes.classe_ano_letivo =? and classes.unidade_id=? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8)' , params[:ano_letivo], params[:unidade]], :group=>'nr_classe' )
              @matriculas = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id INNER JOIN matriculas  ON  matriculas.classe_id = classes.id", :select => "COUNT(*) as qt_mat, left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe ",:conditions=> ['unidades.desativada= 0 AND classes.classe_ano_letivo =? and classes.unidade_id=? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5 OR unidades.tipo_id = 8) AND (matriculas.status ="MATRICULADO" OR matriculas.status ="TRANSFERENCIA" OR matriculas.status ="*REMANEJADO")'  , params[:ano_letivo], params[:unidade]], :group=>'nr_classe')
               @qt_cl=[0,0]
              @qt_mat=[0,0]
              @cl=[0,0]
              @mat=[0,0]
              total=0
              totalMat=0
              session[:total_mat]=0
              session[:qt_mat]=[0,0]
              if @matriculas.empty?
                  render :update do |page|
                     page.replace_html 'estatistica_classe', :partial => 'nao_cadastrado'
                  end
              else
                  for i in 0..(@classes.count-1)
                     session[:qt_mat][i]=@matriculas[i].qt_mat.to_i
                      @qt_cl[i]=@classes[i].quant.to_i
                      @qt_mat[i]=@matriculas[i].qt_mat.to_i
                      total = total + @qt_cl[i].to_f
                      totalMat = totalMat + @qt_mat[i].to_f
                      @cl[i]=@classes[i].nr_classe+": "+ @qt_cl[i].to_s
                      @mat[i]=@matriculas[i].nr_classe+": "+ @qt_mat[i].to_s
                     session[:total_mat]= session[:total_mat] + @qt_mat[i]

                  end
                  for i in 0..(@matriculas.count-1)
                      @cl[i]=@cl[i]+" - "+((@qt_cl[i].to_f/total*100).round(1)).to_s+ "%"
                      @mat[i]=@mat[i]+" - "+((@qt_mat[i].to_f/totalMat*100).round(1)).to_s+ "%"
                 end

                  @classe_ano= @classes
                  unidade= Unidade.find(params[:unidade]).nome
                  ano = params[:ano_letivo]
                  session[:input] = params[:unidade]
                  @graph = open_flash_chart_object(800,350,"/estatistica/classes_infantil?unidade=#{session[:input]}",false,'/')
                  @graph2 = open_flash_chart_object(800,350,"/estatistica/classes_infantil?unidade=#{session[:input]}",false,'/')

                  @static_graph = Gchart.pie(
                   :data => @qt_cl,
                   :title => "CLASSES NA UNIDADE:  #{unidade} -  #{ano} ",
                   :size => '800x350',
                   :format => 'image_tag',
                   :labels => @cl,
                   :bar_colors => '0A0EEA')

                 @static_graph2 = Gchart.pie(
                   :data => @qt_mat,
                   :title => "MATRICULAS POR CLASSE - NA UNIDADE:  #{unidade} -  #{ano} ",
                   :size => '800x350',
                   :format => 'image_tag',
                   :labels => @mat,
                   :bar_colors => '0A0EEA')
                  render :update do |page|
                     page.replace_html 'estatistica_classe', :partial => 'estatisticaclasse'
                  end
              end
          else
             ano_a=(Time.now.year)-4
             ano_b=(Time.now.year)-3
             ano_c=(Time.now.year)-2
             ano_d=(Time.now.year)-1
             ano_e=(Time.now.year)

# ENSINO INFANTIL SEDUC

             @classesIa= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8) and classes.unidade_id=?' ,ano_a, params[:unidade]], :group=>'nr_classe' )
             @classesIb= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8) and classes.unidade_id=?' ,ano_b, params[:unidade]], :group=>'nr_classe' )
             @classesIc= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8) and classes.unidade_id=?' ,ano_c, params[:unidade]], :group=>'nr_classe' )
             @classesId= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8) and classes.unidade_id=?' ,ano_d, params[:unidade]], :group=>'nr_classe' )
             @classesIe= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8) and classes.unidade_id=?' ,ano_e, params[:unidade]], :group=>'nr_classe' )

             @cl=['AEE','BI', 'BII', 'MI', 'MII', 'NI', 'NII', 'MSer']
             @cl_cla=[0,0,0,0,0,0,0,0]
             @cl_clb=[0,0,0,0,0,0,0,0]
             @cl_clc=[0,0,0,0,0,0,0,0]
             @cl_cld=[0,0,0,0,0,0,0,0]
             @cl_cle=[0,0,0,0,0,0,0,0]

              for i in 0..(@classesIa.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIa[i].nr_classe==@cl[n]
                          @cl_cla[n]=@classesIa[i].quant.to_i
                      else
                          if mult==0 and (  @classesIa[i].nr_classe=='BB' or @classesIa[i].nr_classe=='BM' or
                                            @classesIa[i].nr_classe=='MM' or @classesIa[i].nr_classe=='MS' or
                                            @classesIa[i].nr_classe=='MU' or @classesIa[i].nr_classe=='MULTISSERIADA' or
                                            @classesIa[i].nr_classe=='MULTS' or @classesIa[i].nr_classe=='PR')
                              @cl_cla[7]=@cl_cla[7]+@classesIa[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesIb.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIb[i].nr_classe==@cl[n]
                          @cl_clb[n]=@classesIb[i].quant.to_i
                      else
                          if mult==0 and (@classesIb[i].nr_classe=='BB' or @classesIb[i].nr_classe=='BM' or
                              @classesIb[i].nr_classe=='MM' or @classesIb[i].nr_classe=='MS' or
                              @classesIb[i].nr_classe=='MU' or @classesIb[i].nr_classe=='MULTISSERIADA' or
                              @classesIb[i].nr_classe=='MULTS' or @classesIb[i].nr_classe=='PR')
                              @cl_clb[7]=@cl_clb[7]+@classesIb[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesIc.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIc[i].nr_classe==@cl[n]
                          @cl_clc[n]=@classesIc[i].quant.to_i
                      else
                          if mult==0 and (@classesIc[i].nr_classe=='BB' or @classesIc[i].nr_classe=='BM' or
                              @classesIc[i].nr_classe=='MM' or @classesIc[i].nr_classe=='MS' or
                              @classesIc[i].nr_classe=='MU' or @classesIc[i].nr_classe=='MULTISSERIADA' or
                              @classesIc[i].nr_classe=='MULTS' or @classesIc[i].nr_classe=='PR')
                              @cl_clc[7]=@cl_clc[7]+@classesIc[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesId.count-1)
                   mult=0
                   for n in 0..6
                      if @classesId[i].nr_classe==@cl[n]
                          @cl_cld[n]=@classesId[i].quant.to_i
                      else
                          if mult==0 and (@classesId[i].nr_classe=='BB' or @classesId[i].nr_classe=='BM' or
                              @classesId[i].nr_classe=='MM' or @classesId[i].nr_classe=='MS' or
                              @classesId[i].nr_classe=='MU' or @classesId[i].nr_classe=='MULTISSERIADA' or
                              @classesId[i].nr_classe=='MULTS' or @classesId[i].nr_classe=='PR')
                              @cl_cld[7]=@cl_cld[7]+@classesId[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesIe.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIe[i].nr_classe==@cl[n]
                          @cl_cle[n]=@classesIe[i].quant.to_i
                      else
                          if mult==0 and (@classesIe[i].nr_classe=='BB' or @classesIe[i].nr_classe=='BM' or
                              @classesIe[i].nr_classe=='MM' or @classesIe[i].nr_classe=='MS' or
                              @classesIe[i].nr_classe=='MU' or @classesIe[i].nr_classe=='MULTISSERIADA' or
                              @classesIe[i].nr_classe=='MULTS' or @classesIe[i].nr_classe=='PR')
                              @cl_cle[7]=@cl_cle[7]+@classesIe[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

               cl_maior=0
               for n in 0..6
                  if @cl_cla[n]>cl_maior
                      cl_maior=@cl_cla[n]
                  end
                  if @cl_clb[n]>cl_maior
                      cl_maior=@cl_clb[n]
                  end
                  if @cl_clc[n]>cl_maior
                      cl_maior=@cl_clc[n]
                  end
                  if @cl_cld[n]>cl_maior
                      cl_maior=@cl_cld[n]
                  end
                  if @cl_cle[n]>cl_maior
                      cl_maior=@cl_cle[n]
                  end
               end

              unidade= Unidade.find(params[:unidade]).nome
              session[:input] = params[:unidade]
              @graph3 = open_flash_chart_object(800,350,"/estatistica/classes_infantil?unidade=#{session[:input]}",false,'/')
                      @static_graph3 =   Gchart.line(
                      :data => [[@cl_cla[0],@cl_clb[0],@cl_clc[0],@cl_cld[0],@cl_cle[0]],
                                [@cl_cla[1],@cl_clb[1],@cl_clc[1],@cl_cld[1],@cl_cle[1]],
                                [@cl_cla[2],@cl_clb[2],@cl_clc[2],@cl_cld[2],@cl_cle[2]],
                                [@cl_cla[3],@cl_clb[3],@cl_clc[3],@cl_cld[3],@cl_cle[3]],
                                [@cl_cla[4],@cl_clb[4],@cl_clc[4],@cl_cld[4],@cl_cle[4]],
                                [@cl_cla[5],@cl_clb[5],@cl_clc[5],@cl_cld[5],@cl_cle[5]],
                                [@cl_cla[6],@cl_clb[6],@cl_clc[6],@cl_cld[6],@cl_cle[6]],
                                [@cl_cla[7],@cl_clb[7],@cl_clc[7],@cl_cld[7],@cl_cle[7]]],
                      :title => "Nº DE CLASSE EDUCAÇÃO INFANTIL - #{unidade}" ,
                      :grid_lines => ['25,6'],
                      :size => '800x350',
                      :format => 'image_tag',
                      :theme => :thirty8signals,
                      :axis_with_label => 'x,y,r,t',
                      :legend => @cl,
                       # :bg => {:color => 'F5F5F5', :type => 'stripes', :angle => 90},
                       :axis_labels => [[ano_a,ano_b,ano_c,ano_d,ano_e],],
                       :axis_range => [[0,cl_maior]],
                       :axis_with_labels => ['x', 'y']
                       )
              render :update do |page|
                 page.replace_html 'estatistica_classe', :partial => 'estatisticaclasse_seduc'
              end


          end

       else if params[:type_of].to_i == 2
           session[:todos_fundamental] = 1
           session[:todos_infantil] = 0
           t=0
          if params[:ano_letivoF] != '--Todos--'
             @classes = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? and classes.unidade_id=? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7)' , params[:ano_letivoF], params[:unidadeF]], :group=>'nr_classe' )
             @matriculas = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id INNER JOIN matriculas  ON  matriculas.classe_id = classes.id", :select => "COUNT(*) as qt_mat, left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe ",:conditions=> ['classes.classe_ano_letivo =? and classes.unidade_id=? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4 OR unidades.tipo_id = 7) AND (matriculas.status ="MATRICULADO" OR matriculas.status ="TRANSFERENCIA" OR matriculas.status ="*REMANEJADO")'  , params[:ano_letivoF], params[:unidadeF]], :group=>'nr_classe')
              @qt_cl=[0,0]
              @qt_mat=[0,0]
              @cl=[0,0]
              @mat=[0,0]
              total=0
              totalMat=0
              session[:total_mat]=0
              session[:qt_mat]=[0,0]
              if @matriculas.empty?
                  render :update do |page|
                     page.replace_html 'estatistica_classe', :partial => 'nao_cadastrado'
                  end
              else

                  for i in 0..(@classes.count-1)
                    if !@matriculas[i].nil?
                      w=session[:qt_mat][i]=@matriculas[i].qt_mat.to_i
                      @qt_cl[i]=@classes[i].quant.to_i
                      @qt_mat[i]=@matriculas[i].qt_mat.to_i
                      total = total + @qt_cl[i].to_f
                      totalMat = totalMat + @qt_mat[i].to_f
                      @cl[i]=@classes[i].nr_classe+" ano: "+ @qt_cl[i].to_s
                      @mat[i]=@matriculas[i].nr_classe+" ano:"+ @qt_mat[i].to_s
                     session[:total_mat]= session[:total_mat] + @qt_mat[i]
                    end
                  end
                  for i in 0..(@matriculas.count-1)
                      @cl[i]=@cl[i]+" - "+((@qt_cl[i].to_f/total*100).round(1)).to_s+ "%"
                      @mat[i]=@mat[i]+" - "+((@qt_mat[i].to_f/totalMat*100).round(1)).to_s+ "%"
                 end

                  @classe_ano= @classes
                  unidade= Unidade.find(params[:unidadeF]).nome
                  session[:input] = params[:unidadeF]
                  ano = params[:ano_letivoF]
                  @graph = open_flash_chart_object(800,350,"/estatistica/classes_fundamental?unidade=#{session[:input]}",false,'/')
                  @graph2 = open_flash_chart_object(800,350,"/estatistica/classes_fundamental?unidade=#{session[:input]}",false,'/')

                  @static_graph = Gchart.pie(
                   :data => @qt_cl,
                   :title => "CLASSES NA UNIDADE:  #{unidade} -  #{ano} ",
                   :size => '800x350',
                   :format => 'image_tag',
                   :labels => @cl,
                   :bar_colors => '0A0EEA')

                 @static_graph2 = Gchart.pie(
                   :data => @qt_mat,
                   :title => "MATRICULAS POR CLASSE - NA UNIDADE:  #{unidade} -  #{ano} ",
                   :size => '800x350',
                   :format => 'image_tag',
                   :labels => @mat,
                   :bar_colors => '0A0EEA')
t=0
                  render :update do |page|
                     page.replace_html 'estatistica_classe', :partial => 'estatisticaclasse'
                  end
                end
             else
                 ano_a=(Time.now.year)-4
                 ano_b=(Time.now.year)-3
                 ano_c=(Time.now.year)-2
                 ano_d=(Time.now.year)-1
                 ano_e=(Time.now.year)
              
                 @classesFa= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7) and classes.unidade_id=? ' ,ano_a, params[:unidadeF]], :group=>'nr_classe' )
                 @classesFb= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7) and classes.unidade_id=?' ,ano_b, params[:unidadeF]], :group=>'nr_classe' )
                 @classesFc= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7) and classes.unidade_id=?' ,ano_c, params[:unidadeF]], :group=>'nr_classe' )
                 @classesFd= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7) and classes.unidade_id=?' ,ano_d, params[:unidadeF]], :group=>'nr_classe' )
                 @classesFe= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7) and classes.unidade_id=?' ,ano_e, params[:unidadeF]], :group=>'nr_classe' )

                 @clf=['1','2', '3', '4', '5', '6', '7', '8', '9', 'AEE',  'EJA']
                 @clf_cla=[0,0,0,0,0,0,0,0,0,0,0]
                 @clf_clb=[0,0,0,0,0,0,0,0,0,0,0]
                 @clf_clc=[0,0,0,0,0,0,0,0,0,0,0]
                 @clf_cld=[0,0,0,0,0,0,0,0,0,0,0]
                 @clf_cle=[0,0,0,0,0,0,0,0,0,0,0]
t=0
                  for i in 0..(@classesFa.count-1)
    #                   mult=0
                       for n in 0..10
                          if @classesFa[i].nr_classe==@clf[n]
                              @clf_cla[n]=@classesFa[i].quant.to_i
    #                      else
    #                          if mult==0 and (  @classesFa[i].nr_classe=='EJA' or @classesFa[i].nr_classe=='EJA A' or
    #                                            @classesFa[i].nr_classe=='MM' or @classesFa[i].nr_classe=='MS' or
    #                                            @classesFa[i].nr_classe=='MU' or @classesFa[i].nr_classe=='MULTISSERIADA' or
    #                                            @classesFa[i].nr_classe=='MULTS' or @classesFa[i].nr_classe=='PR')
    #                              @clf_cla[7]=@clf_cla[7]+@classesFa[i].quant.to_i
    #                              mult=1
    #                          end
                          end
                       end
                  end

                  for i in 0..(@classesFb.count-1)
    #                   mult=0
                       for n in 0..10
                          if @classesFb[i].nr_classe==@clf[n]
                              @clf_clb[n]=@classesFb[i].quant.to_i
    #                      else
    #                          if mult==0 and (@classesFb[i].nr_classe=='BB' or @classesFb[i].nr_classe=='BM' or
    #                              @classesFb[i].nr_classe=='MM' or @classesFb[i].nr_classe=='MS' or
    #                              @classesFb[i].nr_classe=='MU' or @classesFb[i].nr_classe=='MULTISSERIADA' or
    #                              @classesFb[i].nr_classe=='MULTS' or @classesFb[i].nr_classe=='PR')
    #                              @clf_clb[7]=@clf_clb[7]+@classesIb[i].quant.to_i
    #                              mult=1
    #                          end
                          end
                       end
                  end

                  for i in 0..(@classesFc.count-1)
    #                   mult=0
                       for n in 0..10
                         if @classesFc[i].nr_classe==@clf[n]
                              @clf_clc[n]=@classesFc[i].quant.to_i
    #                      else
    #                          if mult==0 and (@classesFc[i].nr_classe=='BB' or @classesFc[i].nr_classe=='BM' or
    #                              @classesFc[i].nr_classe=='MM' or @classesFc[i].nr_classe=='MS' or
    #                              @classesFc[i].nr_classe=='MU' or @classesFc[i].nr_classe=='MULTISSERIADA' or
    #                              @classesFc[i].nr_classe=='MULTS' or @classesFc[i].nr_classe=='PR')
    #                              @cl_clc[7]=@cl_clc[7]+@classesIc[i].quant.to_i
    #                              mult=1
    #                          end
                          end
                       end
                  end

                  for i in 0..(@classesFd.count-1)
    #                   mult=0
                       for n in 0..10
                          if @classesFd[i].nr_classe==@clf[n]
                              @clf_cld[n]=@classesFd[i].quant.to_i
    #                      else
    #                          if mult==0 and (@classesFd[i].nr_classe=='BB' or @classesFd[i].nr_classe=='BM' or
    #                              @classesFd[i].nr_classe=='MM' or @classesFd[i].nr_classe=='MS' or
    #                              @classesFd[i].nr_classe=='MU' or @classesFd[i].nr_classe=='MULTISSERIADA' or
    #                              @classesFd[i].nr_classe=='MULTS' or @classesFd[i].nr_classe=='PR')
    #                              @clf_cld[7]=@clf_cld[7]+@classesFd[i].quant.to_i
    #                              mult=1
    #                          end
                          end
                       end
                  end

                  for i in 0..(@classesFe.count-1)
    #                   mult=0
                       for n in 0..10
                          if @classesFe[i].nr_classe==@clf[n]
                              @clf_cle[n]=@classesFe[i].quant.to_i
    #                      else
    #                          if mult==0 and (@classesFe[i].nr_classe=='BB' or @classesFe[i].nr_classe=='BM' or
    #                              @classesFe[i].nr_classe=='MM' or @classesFe[i].nr_classe=='MS' or
    #                              @classesFe[i].nr_classe=='MU' or @classesFe[i].nr_classe=='MULTISSERIADA' or
    #                              @classesFe[i].nr_classe=='MULTS' or @classesFe[i].nr_classe=='PR')
    #                              @clf_cle[7]=@clf_cle[7]+@classesFe[i].quant.to_i
    #                              mult=1
    #                          end
                          end
                       end
                  end

                   clf_maior=0
                   for n in 0..10
                      if @clf_cla[n]>clf_maior
                          clf_maior=@clf_cla[n]
                      end
                      if @clf_clb[n]>clf_maior
                          clf_maior=@clf_clb[n]
                      end
                      if @clf_clc[n]>clf_maior
                          clf_maior=@clf_clc[n]
                      end
                      if @clf_cld[n]>clf_maior
                          clf_maior=@clf_cld[n]
                      end
                      if @clf_cle[n]>clf_maior
                          clf_maior=@clf_cle[n]
                      end
                   end

              unidade= Unidade.find(params[:unidadeF]).nome
              session[:input] = params[:unidadeF]
                  ano = params[:ano_letivo]
                  @graph4 = open_flash_chart_object(800,350,"/estatistica/classes_fundamental?unidade=#{session[:input]}",false,'/')
                          @static_graph4 =   Gchart.line(
                          :data => [[@clf_cla[0],@clf_clb[0],@clf_clc[0],@clf_cld[0],@clf_cle[0]],
                                    [@clf_cla[1],@clf_clb[1],@clf_clc[1],@clf_cld[1],@clf_cle[1]],
                                    [@clf_cla[2],@clf_clb[2],@clf_clc[2],@clf_cld[2],@clf_cle[2]],
                                    [@clf_cla[3],@clf_clb[3],@clf_clc[3],@clf_cld[3],@clf_cle[3]],
                                    [@clf_cla[4],@clf_clb[4],@clf_clc[4],@clf_cld[4],@clf_cle[4]],
                                    [@clf_cla[5],@clf_clb[5],@clf_clc[5],@clf_cld[5],@clf_cle[5]],
                                    [@clf_cla[6],@clf_clb[6],@clf_clc[6],@clf_cld[6],@clf_cle[6]],
                                    [@clf_cla[7],@clf_clb[7],@clf_clc[7],@clf_cld[7],@clf_cle[7]],
                                    [@clf_cla[8],@clf_clb[8],@clf_clc[8],@clf_cld[8],@clf_cle[8]],
                                    [@clf_cla[9],@clf_clb[9],@clf_clc[9],@clf_cld[9],@clf_cle[9]],
                                    [@clf_cla[10],@clf_clb[10],@clf_clc[10],@clf_cld[10],@clf_cle[10]]],
                          :title => "Nº DE CLASSE ENSINO FUNDAMENTAL - #{unidade} -  #{ano} ",
                          :grid_lines => ['25,12.5'],
                          :size => '800x350',
                          :format => 'image_tag',
                          :theme => :thirty10signals,
                          :axis_with_label => 'x,y,r,t',
                          :legend => @clf,
                           # :bg => {:color => 'F5F5F5', :type => 'stripes', :angle => 90},
                           :axis_labels => [[ano_a,ano_b,ano_c,ano_d,ano_e],[0,5,10,15,20,25,30,35,40]],
                           :axis_range => [[0,clf_maior]],
                           :axis_with_labels => ['x', 'y']
                           )


                          render :update do |page|
                             page.replace_html 'estatistica_classe', :partial => 'estatisticaclasse_seduc'
                          end


             end
          else if params[:type_of].to_i == 3
              session[:todos_infantil] = 1
              session[:todos_fundamental] = 1
             ano_a=(Time.now.year)-4
             ano_b=(Time.now.year)-3
             ano_c=(Time.now.year)-2
             ano_d=(Time.now.year)-1
             ano_e=(Time.now.year)

# ENSINO INFANTIL SEDUC

             @classesIa= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8) ' ,ano_a], :group=>'nr_classe' )
             @classesIb= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8)' ,ano_b], :group=>'nr_classe' )
             @classesIc= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8)' ,ano_c], :group=>'nr_classe' )
             @classesId= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8)' ,ano_d], :group=>'nr_classe' )
             @classesIe= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 2 OR unidades.tipo_id = 5  OR unidades.tipo_id = 8)' ,ano_e], :group=>'nr_classe' )

             @cl=['AEE','BI', 'BII', 'MI', 'MII', 'NI', 'NII', 'MSer']
             @cl_cla=[0,0,0,0,0,0,0,0]
             @cl_clb=[0,0,0,0,0,0,0,0]
             @cl_clc=[0,0,0,0,0,0,0,0]
             @cl_cld=[0,0,0,0,0,0,0,0]
             @cl_cle=[0,0,0,0,0,0,0,0]

              for i in 0..(@classesIa.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIa[i].nr_classe==@cl[n]
                          @cl_cla[n]=@classesIa[i].quant.to_i
                      else
                          if mult==0 and (  @classesIa[i].nr_classe=='BB' or @classesIa[i].nr_classe=='BM' or
                                            @classesIa[i].nr_classe=='MM' or @classesIa[i].nr_classe=='MS' or
                                            @classesIa[i].nr_classe=='MU' or @classesIa[i].nr_classe=='MULTISSERIADA' or
                                            @classesIa[i].nr_classe=='MULTS' or @classesIa[i].nr_classe=='PR')
                              @cl_cla[7]=@cl_cla[7]+@classesIa[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesIb.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIb[i].nr_classe==@cl[n]
                          @cl_clb[n]=@classesIb[i].quant.to_i
                      else
                          if mult==0 and (@classesIb[i].nr_classe=='BB' or @classesIb[i].nr_classe=='BM' or
                              @classesIb[i].nr_classe=='MM' or @classesIb[i].nr_classe=='MS' or
                              @classesIb[i].nr_classe=='MU' or @classesIb[i].nr_classe=='MULTISSERIADA' or
                              @classesIb[i].nr_classe=='MULTS' or @classesIb[i].nr_classe=='PR')
                              @cl_clb[7]=@cl_clb[7]+@classesIb[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesIc.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIc[i].nr_classe==@cl[n]
                          @cl_clc[n]=@classesIc[i].quant.to_i
                      else
                          if mult==0 and (@classesIc[i].nr_classe=='BB' or @classesIc[i].nr_classe=='BM' or
                              @classesIc[i].nr_classe=='MM' or @classesIc[i].nr_classe=='MS' or
                              @classesIc[i].nr_classe=='MU' or @classesIc[i].nr_classe=='MULTISSERIADA' or
                              @classesIc[i].nr_classe=='MULTS' or @classesIc[i].nr_classe=='PR')
                              @cl_clc[7]=@cl_clc[7]+@classesIc[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesId.count-1)
                   mult=0
                   for n in 0..6
                      if @classesId[i].nr_classe==@cl[n]
                          @cl_cld[n]=@classesId[i].quant.to_i
                      else
                          if mult==0 and (@classesId[i].nr_classe=='BB' or @classesId[i].nr_classe=='BM' or
                              @classesId[i].nr_classe=='MM' or @classesId[i].nr_classe=='MS' or
                              @classesId[i].nr_classe=='MU' or @classesId[i].nr_classe=='MULTISSERIADA' or
                              @classesId[i].nr_classe=='MULTS' or @classesId[i].nr_classe=='PR')
                              @cl_cld[7]=@cl_cld[7]+@classesId[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

              for i in 0..(@classesIe.count-1)
                   mult=0
                   for n in 0..6
                      if @classesIe[i].nr_classe==@cl[n]
                          @cl_cle[n]=@classesIe[i].quant.to_i
                      else
                          if mult==0 and (@classesIe[i].nr_classe=='BB' or @classesIe[i].nr_classe=='BM' or
                              @classesIe[i].nr_classe=='MM' or @classesIe[i].nr_classe=='MS' or
                              @classesIe[i].nr_classe=='MU' or @classesIe[i].nr_classe=='MULTISSERIADA' or
                              @classesIe[i].nr_classe=='MULTS' or @classesIe[i].nr_classe=='PR')
                              @cl_cle[7]=@cl_cle[7]+@classesIe[i].quant.to_i
                              mult=1
                          end
                      end
                   end
              end

               cl_maior=0
               for n in 0..6
                  if @cl_cla[n]>cl_maior
                      cl_maior=@cl_cla[n]
                  end
                  if @cl_clb[n]>cl_maior
                      cl_maior=@cl_clb[n]
                  end
                  if @cl_clc[n]>cl_maior
                      cl_maior=@cl_clc[n]
                  end
                  if @cl_cld[n]>cl_maior
                      cl_maior=@cl_cld[n]
                  end
                  if @cl_cle[n]>cl_maior
                      cl_maior=@cl_cle[n]
                  end
               end

              unidade= 'SEDUC'
              session[:input] = 'SEDUC'
              @graph3 = open_flash_chart_object(800,350,"/estatistica/classes_infantil?unidade=#{session[:input]}",false,'/')
                      @static_graph3 =   Gchart.line(
                      :data => [[@cl_cla[0],@cl_clb[0],@cl_clc[0],@cl_cld[0],@cl_cle[0]],
                                [@cl_cla[1],@cl_clb[1],@cl_clc[1],@cl_cld[1],@cl_cle[1]],
                                [@cl_cla[2],@cl_clb[2],@cl_clc[2],@cl_cld[2],@cl_cle[2]],
                                [@cl_cla[3],@cl_clb[3],@cl_clc[3],@cl_cld[3],@cl_cle[3]],
                                [@cl_cla[4],@cl_clb[4],@cl_clc[4],@cl_cld[4],@cl_cle[4]],
                                [@cl_cla[5],@cl_clb[5],@cl_clc[5],@cl_cld[5],@cl_cle[5]],
                                [@cl_cla[6],@cl_clb[6],@cl_clc[6],@cl_cld[6],@cl_cle[6]],
                                [@cl_cla[7],@cl_clb[7],@cl_clc[7],@cl_cld[7],@cl_cle[7]]],
                      :title => "Nº DE CLASSE EDUCAÇÃO INFANTIL - #{unidade}" ,
                       :grid_lines => ['25,6'],
                      :size => '800x350',
                      :format => 'image_tag',
                      :theme => :thirty8signals,
                      :axis_with_label => 'x,y,r,t',
                      :legend => @cl,
                       # :bg => {:color => 'F5F5F5', :type => 'stripes', :angle => 90},
                       :axis_labels => [[ano_a,ano_b,ano_c,ano_d,ano_e],],
                       :axis_range => [[0,cl_maior]],
                       :axis_with_labels => ['x', 'y']
                       )


# ENSINO FUNDAMENTAL SEDUC

             @classesFa= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7) ' ,ano_a], :group=>'nr_classe' )
             @classesFb= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7)' ,ano_b], :group=>'nr_classe' )
             @classesFc= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7)' ,ano_c], :group=>'nr_classe' )
             @classesFd= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7)' ,ano_d], :group=>'nr_classe' )
             @classesFe= Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id", :select => "COUNT(*) as quant,  left( classes.classe_classe, locate( ' ', classes.classe_classe ) -1 ) AS nr_classe, classes.* ",:conditions=> ['classes.classe_ano_letivo =? AND (unidades.tipo_id = 1 OR unidades.tipo_id = 4  OR unidades.tipo_id = 7)' ,ano_e], :group=>'nr_classe' )

             @clf=['1','2', '3', '4', '5', '6', '7', '8', '9', 'AEE',  'EJA']
             @clf_cla=[0,0,0,0,0,0,0,0,0,0,0]
             @clf_clb=[0,0,0,0,0,0,0,0,0,0,0]
             @clf_clc=[0,0,0,0,0,0,0,0,0,0,0]
             @clf_cld=[0,0,0,0,0,0,0,0,0,0,0]
             @clf_cle=[0,0,0,0,0,0,0,0,0,0,0]

              for i in 0..(@classesFa.count-1)
#                   mult=0
                   for n in 0..10
                      if @classesFa[i].nr_classe==@clf[n]
                          @clf_cla[n]=@classesFa[i].quant.to_i
#                      else
#                          if mult==0 and (  @classesFa[i].nr_classe=='EJA' or @classesFa[i].nr_classe=='EJA A' or
#                                            @classesFa[i].nr_classe=='MM' or @classesFa[i].nr_classe=='MS' or
#                                            @classesFa[i].nr_classe=='MU' or @classesFa[i].nr_classe=='MULTISSERIADA' or
#                                            @classesFa[i].nr_classe=='MULTS' or @classesFa[i].nr_classe=='PR')
#                              @clf_cla[7]=@clf_cla[7]+@classesFa[i].quant.to_i
#                              mult=1
#                          end
                      end
                   end
              end

              for i in 0..(@classesFb.count-1)
#                   mult=0
                   for n in 0..10
                      if @classesFb[i].nr_classe==@clf[n]
                          @clf_clb[n]=@classesFb[i].quant.to_i
#                      else
#                          if mult==0 and (@classesFb[i].nr_classe=='BB' or @classesFb[i].nr_classe=='BM' or
#                              @classesFb[i].nr_classe=='MM' or @classesFb[i].nr_classe=='MS' or
#                              @classesFb[i].nr_classe=='MU' or @classesFb[i].nr_classe=='MULTISSERIADA' or
#                              @classesFb[i].nr_classe=='MULTS' or @classesFb[i].nr_classe=='PR')
#                              @clf_clb[7]=@clf_clb[7]+@classesIb[i].quant.to_i
#                              mult=1
#                          end
                      end
                   end
              end

              for i in 0..(@classesFc.count-1)
#                   mult=0
                   for n in 0..10
                     if @classesFc[i].nr_classe==@clf[n]
                          @clf_clc[n]=@classesFc[i].quant.to_i
#                      else
#                          if mult==0 and (@classesFc[i].nr_classe=='BB' or @classesFc[i].nr_classe=='BM' or
#                              @classesFc[i].nr_classe=='MM' or @classesFc[i].nr_classe=='MS' or
#                              @classesFc[i].nr_classe=='MU' or @classesFc[i].nr_classe=='MULTISSERIADA' or
#                              @classesFc[i].nr_classe=='MULTS' or @classesFc[i].nr_classe=='PR')
#                              @cl_clc[7]=@cl_clc[7]+@classesIc[i].quant.to_i
#                              mult=1
#                          end
                      end
                   end
              end

              for i in 0..(@classesFd.count-1)
#                   mult=0
                   for n in 0..10
                      if @classesFd[i].nr_classe==@clf[n]
                          @clf_cld[n]=@classesFd[i].quant.to_i
#                      else
#                          if mult==0 and (@classesFd[i].nr_classe=='BB' or @classesFd[i].nr_classe=='BM' or
#                              @classesFd[i].nr_classe=='MM' or @classesFd[i].nr_classe=='MS' or
#                              @classesFd[i].nr_classe=='MU' or @classesFd[i].nr_classe=='MULTISSERIADA' or
#                              @classesFd[i].nr_classe=='MULTS' or @classesFd[i].nr_classe=='PR')
#                              @clf_cld[7]=@clf_cld[7]+@classesFd[i].quant.to_i
#                              mult=1
#                          end
                      end
                   end
              end

              for i in 0..(@classesFe.count-1)
#                   mult=0
                   for n in 0..10
                      if @classesFe[i].nr_classe==@clf[n]
                          @clf_cle[n]=@classesFe[i].quant.to_i
#                      else
#                          if mult==0 and (@classesFe[i].nr_classe=='BB' or @classesFe[i].nr_classe=='BM' or
#                              @classesFe[i].nr_classe=='MM' or @classesFe[i].nr_classe=='MS' or
#                              @classesFe[i].nr_classe=='MU' or @classesFe[i].nr_classe=='MULTISSERIADA' or
#                              @classesFe[i].nr_classe=='MULTS' or @classesFe[i].nr_classe=='PR')
#                              @clf_cle[7]=@clf_cle[7]+@classesFe[i].quant.to_i
#                              mult=1
#                          end
                      end
                   end
              end

               clf_maior=0
               for n in 0..10
                  if @clf_cla[n]>clf_maior
                      clf_maior=@clf_cla[n]
                  end
                  if @clf_clb[n]>clf_maior
                      clf_maior=@clf_clb[n]
                  end
                  if @clf_clc[n]>clf_maior
                      clf_maior=@clf_clc[n]
                  end
                  if @clf_cld[n]>clf_maior
                      clf_maior=@clf_cld[n]
                  end
                  if @clf_cle[n]>clf_maior
                      clf_maior=@clf_cle[n]
                  end
               end

              unidade= 'SEDUC'
              session[:input] = 'SEDUC'
              ano = params[:ano_letivo] 
              @graph4 = open_flash_chart_object(800,350,"/estatistica/classes_fundamental?unidade=#{session[:input]}",false,'/')
                      @static_graph4 =   Gchart.line(
                      :data => [[@clf_cla[0],@clf_clb[0],@clf_clc[0],@clf_cld[0],@clf_cle[0]],
                                [@clf_cla[1],@clf_clb[1],@clf_clc[1],@clf_cld[1],@clf_cle[1]],
                                [@clf_cla[2],@clf_clb[2],@clf_clc[2],@clf_cld[2],@clf_cle[2]],
                                [@clf_cla[3],@clf_clb[3],@clf_clc[3],@clf_cld[3],@clf_cle[3]],
                                [@clf_cla[4],@clf_clb[4],@clf_clc[4],@clf_cld[4],@clf_cle[4]],
                                [@clf_cla[5],@clf_clb[5],@clf_clc[5],@clf_cld[5],@clf_cle[5]],
                                [@clf_cla[6],@clf_clb[6],@clf_clc[6],@clf_cld[6],@clf_cle[6]],
                                [@clf_cla[7],@clf_clb[7],@clf_clc[7],@clf_cld[7],@clf_cle[7]],
                                [@clf_cla[8],@clf_clb[8],@clf_clc[8],@clf_cld[8],@clf_cle[8]],
                                [@clf_cla[9],@clf_clb[9],@clf_clc[9],@clf_cld[9],@clf_cle[9]],
                                [@clf_cla[10],@clf_clb[10],@clf_clc[10],@clf_cld[10],@clf_cle[10]]],
                      :title => "Nº DE CLASSE ENSINO FUNDAMENTAL - #{unidade} -  #{ano} ",
                      :grid_lines => ['25,12.5'],
                      :size => '800x350',
                      :format => 'image_tag',
                      :theme => :thirty10signals,
                      :axis_with_label => 'x,y,r,t',
                      :legend => @clf,
                       # :bg => {:color => 'F5F5F5', :type => 'stripes', :angle => 90},
                       :axis_labels => [[ano_a,ano_b,ano_c,ano_d,ano_e],[0,5,10,15,20,25,30,35,40]],
                       :axis_range => [[0,clf_maior]],
                       :axis_with_labels => ['x', 'y']
                       )


                      render :update do |page|
                         page.replace_html 'estatistica_classe', :partial => 'estatisticaclasse_seduc'
                      end

                else if params[:type_of].to_i == 4
                    else if params[:type_of].to_i == 5
                        else if params[:type_of].to_i == 6
                            end
                        end
                    end    #opção 4
                end     #opção 3
            end      #opção 2
        end       #opção 1
   
  end
  




  def graph_por_unidade
    unidade = params[:unidade]
    title = Title.new("Demanda por Unidade: #{Crianca.nome_unidade(unidade)} - Criancas Cadastradas: #{Crianca.todas_crianca_por_unidade(unidade).length}" )
    pie = Pie.new
    pie.start_angle = 0
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
    matriculada = Crianca.matriculas_crianca_por_unidade(unidade)
    nao_matriculada = Crianca.nao_matriculas_crianca_por_unidade(unidade)
    pie.values  = [PieValue.new(matriculada.length,"Crianças Matriculadas na unidade: " + (matriculada.length).to_s), PieValue.new(nao_matriculada.length,"Crianças Não Matriculadas: " + (nao_matriculada.length).to_s)]
    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)
    chart.x_axis = nil
    render :text => chart.to_s
  end

  def pie_chart poll
    @pie_chart ||= {
      :data => poll.choices.collect(&:votes_count),
      :colors => poll.choices.collect {|c| c.winner? ? "264409" : "8A1F11" }
    }
  end


  def classesI_estatistica_ano
      t=0
    if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @unidades_infantil = Unidade.find(:all,  :select => 'nome, id',:conditions =>  ["tipo_id = 2 OR tipo_id = 5 OR tipo_id = 8"], :order => 'nome ASC')
        t=0
    else
       @unidades_infantil = Unidade.find(:all,  :select => 'nome, id ',:conditions =>  ["id=?", current_user.unidade_id], :order => 'nome ASC')
       t=0
    end
   render :partial => 'unidadesI'

 end


  def classesF_estatistica_ano
      t=0
    if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @unidades_fundamental = Unidade.find(:all,  :select => 'nome, id',:conditions =>  ["tipo_id = 1 OR tipo_id = 4 OR tipo_id = 7"], :order => 'nome ASC')
        t=0
    else
       @unidades_fundamental = Unidade.find(:all,  :select => 'nome, id ',:conditions =>  ["id=?", current_user.unidade_id], :order => 'nome ASC')
       t=0
    end
   render :partial => 'unidadesF'

 end










protected

  def load_unidades
   # @unidades =  Unidade.find(:all,  :conditions => ["tipo = 3 or tipo = 1 or tipo = 7 or tipo = 8" ],:order => "nome")
   # @regiaos =  Regiao.find(:all,  :conditions => ["id > 99" ],:order => "nome")

   
  #  $uni=1
  #  $menu=0
  end

   def load_classes
   @ano =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo DESC')
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        #@classe = Classe.find(:all, :order => 'classe_classe ASC')
        @classe = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ? ', Time.now.year  ], :order => 'classes.classe_classe ASC')
        #@classe_todas =  Classe.find(:all, :order => 'classe_classe ASC')
    else
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        #@classe_todas =  Classe.find(:all, :conditions => ['unidade_id = ? ', current_user.unidade_id  ], :order => 'classe_ano_letivo ASC, classe_classe ASC')
        @classe_td =  Classe.find(:all,:select => 'distinct(classe_ano_letivo)',:order => 'classe_ano_letivo ASC')

    end
 end

end
