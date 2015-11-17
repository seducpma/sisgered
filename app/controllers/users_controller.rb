class UsersController < ApplicationController
  before_filter :load_resources
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout :layout?

  before_filter :load_users
  def load_users
    @users =User.find(:all, :order => 'login ASC')
  end
  
  def layout?
    if logged_in?
      "application"
    else
      "user"
    end
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def show
    @users = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @users }
    end
  end
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "USUÁRIO CRIADO COM SUCESSO, ENTRE EM CONTATO COM O ADMINISTRADOR DO SISTEMA PARA LIBERAÇÃO."
    else
      flash[:error]  = "SENHA OU USUÁRIO NÃO AUTORIZADO "
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "BEM VINDO AO SISCAP."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "SENHA OU USUÁRIO NÃO AUTORIZADO, FAVOR ENTRAR EM CONTATO COM A SEDUC."
      redirect_back_or_default('/')
    else
      flash[:error]  = "SENHA OU USUÁRIO NÃO AUTORIZADO, VERIFIQUE A VALIDAÇÃO EM SEU E_MAIL OU ENTRE EM CONTATO COM A SEDUC."
      redirect_back_or_default('/')
    end
  end

  protected

  def load_resources
    @unidades = Unidade.all
  end


end
