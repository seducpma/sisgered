class PasswordsController < ApplicationController
  before_filter :login_required
  skip_before_filter :login_required, :only => [:atualiza,:new, :create,:edit,:update]
  layout 'login'

  def new
  end

  def create
    return unless request.post?
    if @user=User.find_for_forget(params[:email])
      if (@user.size==1)
        @user=User.find(id)
        flash[:notice] = "Um link para efetuar a troca da senha foi enviado para o e-mail cadastrado."
      else
        #lista_user="( "
        lista_user=""
        cont_user=0
        user1=""
        @user.each do |user|
            if (cont_user >= 1)
                lista_user+="|"
                cont_user+=1
            else
                cont_user+=1
                user1=user.login
            end
            lista_user+=user.login
        end
        #lista_user+=" )"
        id=@user[0].id
        @user=User.find(id)
        msg="Um link para efetuar a troca da senha foi enviado para o e-mail cadastrado."
        msg+=" Foram encontrados "+cont_user.to_s+" usuários ("+lista_user+") será alterada a senha do usuário "+user1
        flash[:notice]=msg
      end
      @user.forgot_password
      ChamadoMailer.deliver_forgot_password(@user)
      @user.save
#     flash[:notice] = "Um link para efetuar a troca da senha foi enviado para o e-mail cadastrado."
      redirect_to login_path
    else
      flash[:notice] = "Nenhum usuário cadastrado com o e-mail informado."
      render :action => 'new'
    end
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
        flash[:notice] = @user.save ? "A senha foi alterada com sucesso!" : "ERRO: A senha não foi alterada."
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