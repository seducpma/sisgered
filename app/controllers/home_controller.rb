class HomeController < ApplicationController
  before_filter :login_required

  def index
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

protected


end