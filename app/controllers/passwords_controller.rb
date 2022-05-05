class PasswordsController < ApplicationController
  before_filter :login_required
  skip_before_filter :login_required, :only => [:atualiza,:new, :create,:edit,:update]
  layout 'login'

  def new
  end

  def create
    w1=session[:mais_email]
    session[:email_dig]=params[:email]
    if session[:mais_email]==1
t0=0
       session[:email]= params[:user_id]
        @user_email= User.find(:all, :conditions=> ['id =? AND activated_at is not null', session[:email]])
        id=session[:email]
        w=params[:email]= @user_email[0].email
    else
t0=0
        @user_email=User.find(:all, :conditions=> ['email=? AND activated_at is not null', params[:email]])
        if @user_email.count > 0
t0=0
            w=session[:email]=@user_email[0].id
        end
    end
    if @user_email.count > 1
t0=0
        render  :partial => 'email', :layout => "layouts/login"
    else
t0=0
        return unless request.post?
        #if (@user=User.find_for_forget(params[:email]) and @user.size>0 )
        #if (@user=User.find(:all, :conditions=> ['id =? AND activated_at is not null', session[:email]]))
        if @user_email.count==1
t0=0
            msg="Um link foi enviado para o email cadastrado para efetuar a troca da senha."
            #msg+=" Foi encontrado o usuários "+cont_user.to_s+".  será alterada a senha do usuário ("+lista_user+")"
            flash[:notice]=msg
          @user_email=User.find(@user_email[0].id)
          @user_email.forgot_password
          ChamadoMailer.deliver_forgot_password(@user_email)
          @user_email.save
    #     flash[:notice] = "Um link para efetuar a troca da senha foi enviado para o e-mail cadastrado."
          redirect_to login_path
        else
t0=0
          flash[:notice] = "Nenhum usuário cadastrado com o e-mail informado."
          render :action => 'new'
        end
    end
t0=0
  end

  def edit
    if params[:id].nil?
      render :action => 'new'
      return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
  rescue
    logger.error "Codigo de substituição de senha incompatível."
    flash[:notice] = "ERRO: Algo deu errado, por favor tente novamente ou procure a Informática da SEDUC."
    #redirect_back_or_default('/')
    redirect_to new_user_path
  end

  def atualiza
    if params[:id].nil?
      render :action => 'new'
      return
    end
    if params[:password].blank?
      flash[:notice] = "O campo Senha não pode estar em branco."
      render :action => 'edit', :id => params[:id]
      return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
    return if @user unless params[:password]
      if (params[:password] == params[:password_confirmation])
      #Uncomment and comment lines with @user to have the user logged in after reset - not recommended
        #self.current_user = @user #for the next two lines to work
        #current_user.password_confirmation = params[:password_confirmation]
        #current_user.password = params[:password]
        #@user.reset_password
    #flash[:notice] = current_user.save ? "Password reset" : "Password not reset"
    @user.password_confirmation = params[:password_confirmation]
    @user.password = params[:password]
    @user.reset_password
        #flash[:notice] = @user.save ? "A senha foi alterada com sucesso!" : "ERRO: A senha não foi alterada."
        flash[:notice] = "A senha foi alterada com sucesso!"
      else
        flash[:notice2] = "ERRO: As senhas estão diferentes repita o processo."
        render :action => 'edit', :id => params[:id]
      return
      end
      redirect_to login_path
  rescue
    logger.error "Codigo de substituição de senha incompatível."
        flash[:notice] = "ERRO: Algo deu errado, por favor tente novamente ou procure a Informática da SEDUC."
    redirect_to new_user_path
  end

  def update
  end
end