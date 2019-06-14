class RolesUsersController < ApplicationController
  
  before_filter :load_user
  before_filter :load_role
  layout "application"
  
  def lista_users
    if params[:type_of].to_i == 6
      @role_users = RolesUser.find(:all, :joins => :user, :order => 'login ASC')
    else
      if params[:type_of].to_i == 1
        @role_users = RolesUser.find(:all, :joins => :user, :conditions => ["users.unidade_id = ?", current_user.unidade_id],:order => 'login ASC')
      end
    end

    render :update do |page|
      page.replace_html 'users', :partial => "users"
    end

  end

  def load_user
    @users = User.find_by_sql("SELECT login,id FROM users where id in (select user_id from roles_users where role_id = 6)")
  end

  def listar_user_ass
    render :partial => 'listar_usuarios_associados'
  end

  def load_role
    if current_user.has_role?('admin')
        @roles = Role.find(:all)
    else if current_user.has_role?('direcao_infantil')
          @roles = Role.find(:all, :conditions => ['id = 10 or id = 12 or id = 6 or id =8'])
         else if current_user.has_role?('direcao_fundamental')
                @roles = Role.find(:all, :conditions => ['id > 4 and id < 9'])
               else
              end
         end
    end
    @role_users = RolesUser.find(:all)
  end


  def index
    $new_id = 0
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @role_users = RolesUser.find(:all, :joins => :user, :conditions=> ['users.activated_at is not null'],:order => 'login ASC')
    else
         @role_users = RolesUser.find(:all, :joins => :user,:conditions => ['users.unidade_id = ? AND users.activated_at is not null', current_user.unidade_id], :order => 'login ASC')
    end
   respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role_users }
    end

  end

  def show
    @roles_user = RolesUser.find(params[:id])
        respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @roles_user }
    end
  end


  def new
    @role_user = RolesUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role_user }
    end
  end

  def edit
    @role_user = RolesUser.find(params[:id])
  end

  def create
     @role_user = RolesUser.new(params[:roles_user])
    respond_to do |format|
      if @role_user.save
        flash[:notice] = 'OK'
        format.html { redirect_to(@role_user) }
        format.xml  { render :xml => @role_user, :status => :created, :location => @role_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /role_users/1
  # PUT /role_users/1.xml
  def update
    @role_user = RolesUser.find(params[:id])
    @role_user.role_id = $new_role_id
    respond_to do |format|
      if @role_user.update_attributes(params[:role_user])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@role_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @role_user = RolesUser.find(params[:id])
    @role_user.destroy

    respond_to do |format|
      format.html { redirect_to(roles_users_url) }
      format.xml  { head :ok }
    end
  end
  def role_id
    t=0
    $new_role_id = params[:roles_user_role_id]
    render :text => ''
  end
end