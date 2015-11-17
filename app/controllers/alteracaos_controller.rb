class AlteracaosController < ApplicationController

  require_role ["admin","planejamento"]
  #before_filter :login_require

  layout :define_layout

  def define_layout
      current_user.layout
  end

  def index
  end
  
  def alterar_classe
   @criancas_alteracao = Crianca.find( :all,:conditions => ["status = 'NA_DEMANDA'" ],:order => 'nome ASC')
   for crianca in @criancas_alteracao
     t0=crianca.nascimento
      t1= crianca.grupo_id

    if  (crianca.nascimento <= '2015-10-31'.to_date and crianca.nascimento >= '2015-02-01'.to_date)
         crianca.grupo_id 	= 11
    else if(crianca.nascimento <= '2015-01-31'.to_date and crianca.nascimento >= '2014-07-01'.to_date)
            crianca.grupo_id = 22

         else if(crianca.nascimento <= '2014-06-30'.to_date and crianca.nascimento >= '2013-07-01'.to_date)
               crianca.grupo_id = 44
             else if(crianca.nascimento <= '2013-06-30'.to_date and crianca.nascimento >= '2012-07-01'.to_date)
                     crianca.grupo_id = 55
                  else if(crianca.nascimento <= '2012-06-30'.to_date and crianca.nascimento >= '2011-07-01'.to_date)
                          crianca.grupo_id = 66
                       else if(crianca.nascimento <= '2011-06-30'.to_date and crianca.nascimento >= '2010-07-01'.to_date)
                               crianca.grupo_id = 77
                            end
                      end
                   end
              end
           end
      end
    crianca.save

   end
    render :update do |page|
        page.replace_html 'confirma', :text => "Novo ano iniciado Novo ano iniciado Novo ano iniciado"
      end
  end

def altera

end



end

