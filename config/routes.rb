ActionController::Routing::Routes.draw do |map|
  map.resources :logs
  map.resources :roles_users
  map.resources :users

  map.resource :session
  map.resources :unidades
  map.resources :criancas, :collection => {:impressao => :get, :consultas => :get, :impressao_class_unidade => :get, :impressao_class_classe => :get, :status => :get, :impressao_geral => :get, :status => :get}
  map.resources :grupos
  map.resources :regiaos
  map.resources :regiaos
  map.resources :graficos, :collection => {:impressao_unidade => :get,   :impressao_geral => :get}
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "home"
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.grafico '/grafico', :controller => 'grafico'
  map.grafico_geral '/grafico/grafico_demanda_geral', :controller => 'grafico', :action => 'grafico_geral_demanda'
  map.grafico_por_unidade '/grafico/crianca_por_unidade', :controller => 'grafico', :action => 'crianca_por_unidade'
  map.relatorio_crianca '/crianca/relatorio_crianca', :controller => 'criancas', :action => 'relatorio_crianca'
  map.consulta_geral '/geral', :controller => 'criancas', :action => 'relatorio_geral'
  map.consulta_unidade '/unidade', :controller => 'criancas', :action => 'consulta_unidade'
  map.consulta_unidade_status '/unidade_status', :controller => 'criancas', :action => 'consulta_unidade_status'
  map.consulta_classe '/consulta_classe', :controller => 'criancas', :action => 'consulta_classe'

  map.grafico '/grafico', :controller => 'grafico'
  map.grafico_geral '/grafico/grafico_demanda_geral', :controller => 'grafico', :action => 'grafico_geral_demanda'
  map.grafico_por_unidade '/grafico/crianca_por_unidade', :controller => 'grafico', :action => 'crianca_por_unidade'


  map.resources :classes
  map.resources :informativos
  map.resources :logs
  map.resources :unidades
  map.resources :fichas

  

  
  map.consultacrianca '/consultacrianca', :controller => 'criancas', :action => 'consultacrianca'
  
  
  
  
  
  

  map.resources :roles_users, :collection => {:lista_users => :get}
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resource :password
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.resources :users
  map.resource :session
  map.home '', :controller => 'home', :action => 'index'
  map.root :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.geo "/geos/geo/:id", :controller => "geos", :action => "geo"
  
end
