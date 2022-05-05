class HomeController < ApplicationController
  before_filter :login_required 

  def index
  end
  
  def fora_do_ar

  end

  def sobresis
    render :update do |page|
        page.replace_html 'tela_sobre', :text => ''
        page.replace_html 'tela_sobre', :partial => 'sobre'
    end
  end

  def acertar_online_users
    @users = User.all
    @users.each do |user|
      @online_user = OnlineUser.new
      @online_user.user_id = user.id
      @online_user.online = 0
      @online_user.save
    end
    render :nothing => true
  end

def download_classificacao
    send_file("#{RAILS_ROOT}/public/documentos/classificacao.doc" , :type=>"text/msword")
  end


def protocolo_covid
  send_file("#{RAILS_ROOT}/public/documentos/protocolo.pdf" , :type=>"pdf")
end


protected


end