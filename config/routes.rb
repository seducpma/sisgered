ActionController::Routing::Routes.draw do |map|

  map.resources :transferencias,:collection => { :editar_transferencia=>:get}
  map.resources :disciplinas
  map.resources :atribuicaos, :collection => { :consulta_classe=>:get, :relatorios_classe=>:get, :lancar_notas => :get, :relatorio_classe => :get, :mapa_classe => :get, :consulta_professor_classe=>:get }
  map.resources :classes_professors
  map.resources :notas_alunos
  map.resources :notas, :collection => { :lancar_notas => :get, :lancamentos_notas =>:get }
  map.resources :classes_alunos
  map.resources :classes,:collection => { :editar_classe=>:get}
  map.resources :professors,:collection => { :consulta_classe=>:get}
  map.resources :tipos
  map.resources :unidades,  :collection => {:consultas => :get}
  map.resources :socioeconomicos
  map.resources :saudes
  map.resources :pessoas
  map.resources :alunos, :collection => {:consulta_ficha => :get , :editar_ficha=>:get}

  map.resources :logs
  map.resources :roles_users
  map.resources :users

  map.resource :session
  map.resources :criancas, :collection => {:impressao => :get, :consultas => :get, :impressao_class_unidade => :get, :impressao_class_classe => :get, :status => :get, :impressao_geral => :get, :status => :get, :update => :put}
  map.resources :grupos
  map.resources :regiaos
  map.resources :regiaos
  map.resources :graficos
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


  map.alterar '/alterar', :controller => 'alteracaos', :action => 'alterar'
  map.altera_status 'altera_status', :controller => 'alteracaos', :action => 'alterar_classe'
  map.alteracao_status 'alteracao_status', :controller => 'criancas', :action => 'alteraracao_status'


  map.grafico '/grafico', :controller => 'grafico'
  map.grafico_geral '/grafico/grafico_demanda_geral', :controller => 'grafico', :action => 'grafico_demanda_geral'
  map.grafico_unidade '/grafico/grafico_demanda_unidade', :controller => 'grafico', :action => 'grafico_demanda_unidade'

  map.impressao_geral '/grafico/impressao_geral', :controller => 'grafico', :action => 'impressao_geral'
  map.impressao_alunos '/impressao_alunos', :controller => 'alunos', :action => 'impressao_alunos'
  map.impressao_saude '/impressao_saude', :controller => 'saudes', :action => 'impressao_saude'
  map.impressao_socioeconomico '/impressao_socioeconomico', :controller => 'socioeconomicos', :action => 'impressao_socioeconomico'
  map.impressao_ficha_completa '/impressao_ficha_completa', :controller => 'socioeconomicos', :action => 'impressao_ficha_completa'
  map.impressao_ficha '/impressao_ficha', :controller => 'alunos', :action => 'impressao_ficha'
  map.impressao_classe '/impressao_classe', :controller => 'classes', :action => 'impressao_classe'
  map.impressao_lista '/impressao_lista', :controller => 'classes', :action => 'impressao_lista'
  map.impressao_bolsa_familia '/impressao_bolsa_familia', :controller => 'alunos', :action => 'impressao_bolsa_familia'
  map.impressao_relatorio_aluno '/impressao_relatorio_aluno', :controller => 'atribuicaos', :action => 'impressao_relatorio_aluno'
  map.impressao_relatorio_classe '/impressao_relatorio_classe', :controller => 'atribuicaos', :action => 'impressao_relatorio_classe'
  map.impressao_relatorio_professor '/impressao_relatorio_professor', :controller => 'atribuicaos', :action => 'impressao_relatorio_professor'
  map.impressao_relatorio_mapa '/impressao_relatorio_mapa', :controller => 'atribuicaos', :action => 'impressao_lencol'
  map.impressao_lancamentos '/impressao_lancamentos', :controller => 'atribuicaos', :action => 'impressao_lancamentos'
  map.impressao_alteracao_lancamentos '/impressao_alteracao_lancamentos', :controller => 'notas', :action => 'impressao_alteracao_lancamentos'
  map.impressao_lancamentos_notas '/impressao_lancamentos_notas', :controller => 'notas', :action => 'impressao_lancamentos_notas'
  map.montar_classe '/montar_classe', :controller => 'classes', :action => 'montar_classe'

  map.alteracao '/altera', :controller => 'alteracaos', :action => 'altera'

  map.resources :classes
  map.resources :informativos
  map.resources :logs
  map.resources :fichas

  map.editar_ficha_cadastral '/editar_ficha_cadastral', :controller => 'alunos', :action => 'editar_ficha_cadastral'
  map.editar_transferencia_aluno '/editar_transferencia_aluno', :controller => 'transferencias', :action => 'editar_transferencia_aluno'
  map.editar_classe_aluno '/editar_classe_aluno', :controller => 'classes', :action => 'editar_classe_aluno'


  map.consulta_unidade '/consulta_unidade', :controller => 'unidades', :action => 'consulta_unidade'
  map.consultaprofessor '/consultaprofessor', :controller => 'professors', :action => 'consultaprofessor'
  map.consulta_professor_nome '/consulta_professor_nome', :controller => 'professors', :action => 'consulta_nome'
  map.consulta_ficha_cadastral '/consulta_ficha_cadastral', :controller => 'alunos', :action => 'consulta_ficha_cadastral'
  map.consulta_classe_aluno '/consulta_classe_aluno', :controller => 'classes', :action => 'consulta_classe_aluno'
  map.consulta_classe '/consulta_classe', :controller => 'classes', :action => 'consulta_classe'
  map.consulta_lista_classe '/consulta_lista_classe', :controller => 'classes', :action => 'consulta_lista_classe'
  map.consulta_lista '/consulta_lista', :controller => 'classes', :action => 'consulta_lista'
  map.consultacrianca '/consultacrianca', :controller => 'criancas', :action => 'consultacrianca'
  map.consulta_responsaveis '/consulta_responsaveis', :controller => 'alunos', :action => 'consulta_responsaveis'
  map.consulta_reponsavel '/consulta_reponsavel', :controller => 'alunos', :action => 'consulta_reponsavel'
  map.consulta_bolsa_familia '/consulta_bolsa_familia', :controller => 'alunos', :action => 'consulta_bolsa_familia'
  map.consulta_classe_professor '/consulta_classe_professor', :controller => 'professors', :action => 'consulta_classe_professor'
  map.consulta_classe_nota1 '/consulta_classe_nota1', :controller => 'atribuicaos', :action => 'consulta_classe_nota1'
  map.consulta_transferencia '/consulta_transferencia', :controller => 'transferencias', :action => 'consulta_transferencia'
  map.consulta_transferencia_classe '/consulta_transferencia_classe', :controller => 'transferencias', :action => 'consulta_transferencia_classe'
  map.consulta_classe_nota '/consulta_classe_nota', :controller => 'atribuicaos', :action => 'consulta_classe_nota'

  map.mapa_de_classe'/mapa_de_classe', :controller => 'atribuicaos', :action => 'mapa_de_classe'
  map.lancar_notas_alunos '/lancar_notas_alunos', :controller => 'notas', :action => 'lancar_notas_alunos'
  map.lancar_notas_alunos_atribuicaos '/lancar_notas_alunos_atribuicaos', :controller => 'atribuicaos', :action => 'lancar_notas_alunos_atribuicao'

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

  #map.resource :password
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.resource :password


  map.resources :users
  map.resource :session
  map.home '', :controller => 'home', :action => 'index'
  map.root :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.geo "/geos/geo/:id", :controller => "geos", :action => "geo"
  
end
