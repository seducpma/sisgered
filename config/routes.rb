ActionController::Routing::Routes.draw do |map|
  map.resources :faltas, :collection => { :lancar_faltas => :get, :lancar_faltas_inf => :get, :gerar_faltas=>:get,  :gerar_faltas_todas=>:get, :lancar_faltas_editar => :get}

  map.resources :aulas_faltas, :collection => { :relatorio_falta_mes=>:get, :index2=>:get , :index3=>:get,  :relatorio_falta_mes_professor => :get , :relatorio_falta_mes_funcionario => :get}

  map.resources :funcionarios, :collection => { :consulta=>:get}
  map.resources :aulas_eventuals, :collection => { :index2=>:get,   :relatorio_eventual_mes_professor => :get,  :relatorio_eventual_mes_unidade => :get}
  map.resources :eventuals
  map.resources :ufaltas
  map.resources :relatorios,:collection => { :relatorio=>:get, :consultas=>:get, :consultas_observacao =>:get, :editar=>:get}
  map.resources :observacao_historicos,:collection => { :aviso=>:get}
  map.resources :observacao_notas
  map.resources :situacao_alunos
  map.resources :matriculas,:collection => { :transferencia=>:get, :alterar=>:get, :saidas=>:get, :consultar => :get, :new1 => :get, :remanejamento=>:get, :aviso=>:get, :aviso1=>:get, :aviso2=>:get, :alunos_matricula => :get , :matricular => :get , :matricular_alunos => :get}
  map.resources :transferencias,:collection => { :editar_transferencia=>:get}
  map.resources :disciplinas
  map.resources :atribuicaos, :collection => { :consulta_classe=>:get, :relatorios_classe=>:get, :relatorios_anterior_classe=>:get, :lancar_notas => :get, :relatorio_classe => :get, :mapa_classe => :get, :mapa_classe_anterior => :get,:consulta_professor_classe=>:get, :historico_aluno=>:get, :historico => :get, :transferencia_aluno => :get, :transferenciaA=> :get,  :reserva_vaga=> :get,  :reserva_vagas=> :get,  :relatorio_observacoes=> :get, :editar_atribuicao=>:get, :aviso=>:get}
  map.resources :classes_professors
  map.resources :notas_alunos
  map.resources :notas, :collection => {:lancar_notas => :get, :lancamentos_notas =>:get, :lancamentos_observacaos =>:get, :lancamentos_compensacao =>:get, :relatorio_classe => :get ,  :new1 => :get, :lancamento_aulas_compensadas => :get }
  map.resources :classes_alunos
  map.resources :classes,:collection => { :editar_classe=>:get, :gerar_notas=>:get, :nucleo_basico =>:get, :consulta_classe_fone =>:get}
  map.resources :professors,:collection => { :consulta_classe=>:get,  :consulta_classe_anterior=>:get }
  map.resources :tipos
  map.resources :unidades,  :collection => {:consultas => :get}
  map.resources :socioeconomicos
  map.resources :saudes
  map.resources :pessoas
  map.resources :alunos, :collection => {:consulta_ficha => :get ,  :consulta_cadastro => :get, :editar_ficha=>:get, :certeza =>:get}
  map.resources :logs
  map.resources :roles_users
  map.resources :users, :collection => {:aviso => :get}
  map.resources :classes
  map.resources :informativos
  map.resources :logs
  map.resources :fichas
  map.resource :session

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



  map.new_continua  '/new_continua', :controller => 'saudes', :action => 'new_continua'
  map.new_continua_econ  '/new_continua_econ', :controller => 'socioeconomicos', :action => 'new_continua'
  map.aulas_eventuals2 '/aulas_eventuals2', :controller => 'aulas_eventuals', :action => 'index2'
  map.aulas_faltas2 '/aulas_faltas2', :controller => 'aulas_faltas', :action => 'index2'
  map.aulas_faltas3 '/aulas_faltas3', :controller => 'aulas_faltas', :action => 'index3'
  map.construcao '/construcao', :controller => 'alunos', :action => 'construcao'
  map.montar_classe '/montar_classe', :controller => 'classes', :action => 'montar_classe'
  map.new_disciplinanota '/new_disciplinanota', :controller => 'disciplinas', :action => 'new_disciplinanota'
  map.create_discipina_nota '/create_discipina_nota', :controller => 'disciplinas', :action => 'create_discipina_nota'


  #map.teste '/teste', :controller => 'disciplinas', :action => 'teste'
  map.alterar '/alterar', :controller => 'alteracaos', :action => 'alterar'
  map.altera_status 'altera_status', :controller => 'alteracaos', :action => 'alterar_classe'
  map.alteracao_status 'alteracao_status', :controller => 'criancas', :action => 'alteraracao_status'
  map.voltar_lancamento_notas '/voltar_lancamento_notas', :controller => 'notas', :action => 'voltar_lancamento_notas'
  map.voltar_lancamento_faltas '/voltar_lancamento_faltas', :controller => 'faltas', :action => 'voltar_lancamento_faltas'
  map.notas_lancamentos '/notas_lancamentos', :controller => 'notas', :action => 'notas_lancamentos'
  #map.lancamentos_aulas_compensadas '/lancamentos_aulas_compensadas', :controller => 'notas', :action => 'lancamentos_aulas_compensadas'
  #map.aulas_compensadas '/aulas_compensadas', :controller => 'notas', :action => 'aulas_compensadas'
  map.resources :criancas, :collection => {:impressao => :get, :consultas => :get, :impressao_class_unidade => :get, :impressao_class_classe => :get, :impressao_geral => :get, :status => :get, :update => :put}


  map.relatorio_falta_classe '/relatorio_falta_classe', :controller => 'faltas', :action => 'relatorio_falta_classe'
  map.relatorio_classe_falta '/relatorio_classe_falta', :controller => 'faltas', :action => 'relatorio_classe_falta'
  map.relatorio_falta_unidade '/relatorio_falta_unidade', :controller => 'faltas', :action => 'relatorio_falta_unidade'
  map.relatorio_unidade_falta '/relatorio_unidade_falta', :controller => 'faltas', :action => 'relatorio_unidade_falta'



  map.impressao_geral '/grafico/impressao_geral', :controller => 'grafico', :action => 'impressao_geral'
  map.impressao_alunos '/impressao_alunos', :controller => 'alunos', :action => 'impressao_alunos'
  map.impressao_saude '/impressao_saude', :controller => 'saudes', :action => 'impressao_saude'
  map.impressao_socioeconomico '/impressao_socioeconomico', :controller => 'socioeconomicos', :action => 'impressao_socioeconomico'
  map.impressao_ficha_completa '/impressao_ficha_completa', :controller => 'socioeconomicos', :action => 'impressao_ficha_completa'
  map.impressao_ficha '/impressao_ficha', :controller => 'alunos', :action => 'impressao_ficha'
  map.impressao_classe '/impressao_classe', :controller => 'classes', :action => 'impressao_classe'
  map.impressao_classe_fone '/impressao_classe_fone', :controller => 'classes', :action => 'impressao_classe_fone'
  map.impressao_piloto '/impressao_piloto', :controller => 'classes', :action => 'impressao_piloto'
  map.impressao_lista '/impressao_lista', :controller => 'classes', :action => 'impressao_lista'
  map.impressao_bolsa_familia '/impressao_bolsa_familia', :controller => 'alunos', :action => 'impressao_bolsa_familia'
  map.impressao_relatorio_aluno '/impressao_relatorio_aluno', :controller => 'atribuicaos', :action => 'impressao_relatorio_aluno'
  map.impressao_relatorio_classe '/impressao_relatorio_classe', :controller => 'atribuicaos', :action => 'impressao_relatorio_classe'
  map.impressao_relatorio_professor '/impressao_relatorio_professor', :controller => 'atribuicaos', :action => 'impressao_relatorio_professor'
  map.impressao_relatorio_mapa1 '/impressao_relatorio_mapa1', :controller => 'atribuicaos', :action => 'impressao_lencol1'
  map.impressao_relatorio_mapa2 '/impressao_relatorio_mapa2', :controller => 'atribuicaos', :action => 'impressao_lencol2'
  map.impressao_relatorio_mapa3 '/impressao_relatorio_mapa3', :controller => 'atribuicaos', :action => 'impressao_lencol3'
  map.impressao_relatorio_mapa4 '/impressao_relatorio_mapa4', :controller => 'atribuicaos', :action => 'impressao_lencol4'
  map.impressao_relatorio_mapa5 '/impressao_relatorio_mapa5', :controller => 'atribuicaos', :action => 'impressao_lencol5'
  map.impressao_nota_final '/impressao_nota_final', :controller => 'historicos', :action => 'impressao_nota_final'
  map.impressao_lancamentos '/impressao_lancamentos', :controller => 'atribuicaos', :action => 'impressao_lancamentos'
  map.impressao_alteracao_lancamentos '/impressao_alteracao_lancamentos', :controller => 'notas', :action => 'impressao_alteracao_lancamentos'
  map.impressao_lancamentos_notas '/impressao_lancamentos_notas', :controller => 'notas', :action => 'impressao_lancamentos_notas'
  map.impressao_transferencia_aluno'impressao_transferencia_aluno', :controller => 'atribuicaos', :action => 'impressao_transferencia_aluno'
  #map.impressao_historico'impressao_historico', :controller => 'atribuicaos', :action => 'impressao_historico'
  map.impressao_historico'impressao_historico', :controller => 'historicos', :action => 'impressao_historico'
  map.impressao_historico_aluno'impressao_historico_aluno', :controller => 'atribuicaos', :action => 'impressao_historico_aluno'
  map.impressao_fapea '/impressao_fapea', :controller => 'relatorios', :action => 'impressao_fapea'
  map.impressao_fapea1 '/impressao_fapea1', :controller => 'relatorios', :action => 'impressao_fapea1'
  map.impressao_fapea2 '/impressao_fapea2', :controller => 'relatorios', :action => 'impressao_fapea2'
  map.impressao_fapeaT '/impressao_fapeaT', :controller => 'relatorios', :action => 'impressao_fapeaT'
  map.impressao_fapeaT1 '/impressao_fapeaT1', :controller => 'relatorios', :action => 'impressao_fapeaT1'
  map.impressao_fapeaT2 '/impressao_fapeaT2', :controller => 'relatorios', :action => 'impressao_fapeaT2'
  map.impressao_faltas '/impressao_faltas', :controller => 'aulas_faltas', :action => 'impressao_faltas'
  map.impressao_faltas_professor '/impressao_faltas_professor', :controller => 'aulas_faltas', :action => 'impressao_faltas_professor'
  map.impressao_faltas_funcionario '/impressao_faltas_funcionario', :controller => 'aulas_faltas', :action => 'impressao_faltas_funcionario'
  map.impressao_eventuals '/impressao_eventuals', :controller => 'aulas_eventuals', :action => 'impressao_eventuals'
  map.impressao_eventuals_professor '/impressao_eventuals_professor', :controller => 'aulas_eventuals', :action => 'impressao_eventuals_professor'
  map.impressao_relatorio_faltas_classe'/impressao_relatorio_faltas_classe', :controller => 'faltas', :action => 'impressao_relatorio_faltas_classe'

  #map.download_historico '/download_historico', :controller => 'atribuicaos', :action => 'arquivo_historico'
  map.download_historico '/download_historico', :controller => 'atribuicaos', :action => 'download_historico'
  map.download_historico '/download_historico', :controller => 'historicos', :action => 'arquivo_historico'
  map.resultado_final '/resultado_final', :controller => 'historicos', :action => 'resultado_final'
  map.final_resultado '/final_resultado', :controller => 'historicos', :action => 'final_resultado'
  map.impressao_unidade '/impressao_unidade', :controller => 'aulas_eventuals', :action => 'impressao_unidade'
  map.renumera '/renumera', :controller => 'classes', :action => 'renumera'


  map.alteracao '/altera', :controller => 'alteracaos', :action => 'altera'
  map.alteracao_matricula '/alteracao_matricula', :controller => 'matriculas', :action => 'alteracao_matricula'
  map.reprovacao '/reprovacao', :controller => 'matriculas', :action => 'reprovacao'
  map.reprovacao_aluno '/reprovacao_aluno', :controller => 'matriculas', :action => 'reprovacao_aluno'
  map.show_reprovado '/show_reprovado', :controller => 'matriculas', :action => 'show_reprovado'
  map.editar_ficha_cadastral '/editar_ficha_cadastral', :controller => 'alunos', :action => 'editar_ficha_cadastral'
  map.editar_transferencia_aluno '/editar_transferencia_aluno', :controller => 'transferencias', :action => 'editar_transferencia_aluno'
  map.editar_classe_aluno '/editar_classe_aluno', :controller => 'classes', :action => 'editar_classe_aluno'
  map.editar_atribuicao_classe '/editar_atribuicao_classe', :controller => 'atribuicaos', :action => 'editar_atribuicao_classe'
  map.show_editar '/show_editar', :controller => 'atribuicaos', :action => 'show_editar'
  map.new2_obs_notas '/new2_obs_notas', :controller => 'observacao_notas', :action => 'new2'

  map.consulta_professor_eventual '/consulta_professor_eventual', :controller => 'eventuals', :action => 'consultas'
  map.consulta_unidade '/consulta_unidade', :controller => 'unidades', :action => 'consulta_unidade'
  map.consultaprofessor '/consultaprofessor', :controller => 'professors', :action => 'consultaprofessor'
  map.saida_transf '/saida_transf', :controller => 'matriculas', :action => 'saida_transf'
  map.consulta_professor_nome '/consulta_professor_nome', :controller => 'professors', :action => 'consulta_nome'

  map.consulta_ficha_cadastral '/consulta_ficha_cadastral', :controller => 'alunos', :action => 'consulta_ficha_cadastral'
  map.consulta_classe_aluno '/consulta_classe_aluno', :controller => 'classes', :action => 'consulta_classe_aluno'
  map.consulta_classe_fone1 '/consulta_classe_fone1', :controller => 'classes', :action => 'consulta_classe_fone1'
  map.consulta_classe_piloto'/consulta_classe_piloto', :controller => 'classes', :action => 'consulta_classe_piloto'
  map.consulta_piloto'/consulta_piloto', :controller => 'classes', :action => 'consulta_piloto'
  map.consulta_classe '/consulta_classe', :controller => 'classes', :action => 'consulta_classe'
  map.consulta_classe_anteriores '/consulta_classe_anteriores', :controller => 'classes', :action => 'consulta_classe_anteriores'
  map.consulta_lista_classe '/consulta_lista_classe', :controller => 'classes', :action => 'consulta_lista_classe'
  map.consulta_lista '/consulta_lista', :controller => 'classes', :action => 'consulta_lista'
  map.consultacrianca '/consultacrianca', :controller => 'criancas', :action => 'consultacrianca'
  map.consulta_responsaveis '/consulta_responsaveis', :controller => 'alunos', :action => 'consulta_responsaveis'
  map.consulta_reponsavel '/consulta_reponsavel', :controller => 'alunos', :action => 'consulta_reponsavel'
  map.consulta_bolsa_familia '/consulta_bolsa_familia', :controller => 'alunos', :action => 'consulta_bolsa_familia'
  map.consulta_classe_professor '/consulta_classe_professor', :controller => 'professors', :action => 'consulta_classe_professor'
  map.consulta_classe_anterior_professor '/consulta_classe_anterior_professor', :controller => 'professors', :action => 'consulta_classe_anterior_professor'
  map.consulta_classe_nota1 '/consulta_classe_nota1', :controller => 'atribuicaos', :action => 'consulta_classe_nota1'
  map.consulta_transferencia '/consulta_transferencia', :controller => 'transferencias', :action => 'consulta_transferencia'
  map.consulta_transferencia_classe '/consulta_transferencia_classe', :controller => 'transferencias', :action => 'consulta_transferencia_classe'
  map.consulta_classe_nota '/consulta_classe_nota', :controller => 'atribuicaos', :action => 'consulta_classe_nota'
  map.consultar_matricula '/consultar_matricula', :controller => 'matriculas', :action => 'consultar_matricula'
  map.consulta_reprovados '/consulta_reprovados', :controller => 'matriculas', :action => 'consulta_reprovados'
  map.consulta_reprovados1 '/consulta_reprovados1', :controller => 'matriculas', :action => 'consulta_reprovados1'
  map.consultar_relatorio '/consultar_relatorio', :controller => 'relatorio', :action => 'consulta_relatorio'
  #map.consulta_observacoes '/consulta_observacoes', :controller => 'atribuicaos', :action => 'consulta_observacoes'
  #map.consulta_relatorios '/consulta_relatorios', :controller => 'relatorios', :action => 'consulta_relatorios'
  map.consulta_fapea '/consulta_fapea', :controller => 'relatorios', :action => 'consulta_fapea'

  map.editar_relatorio '/editar_relatorios', :controller => 'relatorios', :action => 'editar'
  map.consulta_observacoes '/consulta_observacoes', :controller => 'relatorios', :action => 'consulta_observacoes'
  map.consulta_atribuicao '/consulta_atribuicao', :controller => 'atribuicaos', :action => 'consulta_atribuicao'

  map.historico'/historico', :controller => 'historicos', :action => 'historico'
  map.historicoContinua'/historicoContinua', :controller => 'historicos', :action => 'historicoContinua'
  map.historicoatri'/historicoatri', :controller => 'atribuicaos', :action => 'historico_aluno'
  map.historico_aluno'/historico_aluno', :controller => 'historicos', :action => 'historico_aluno'
  map.mapa_de_classe'/mapa_de_classe', :controller => 'atribuicaos', :action => 'mapa_de_classe'
  map.mapa_de_classe_anterior'/mapa_de_classe_anterior', :controller => 'atribuicaos', :action => 'mapa_de_classe_anterior'
  map.lancar_notas_alunos '/lancar_notas_alunos', :controller => 'notas', :action => 'lancar_notas_alunos'
  map.lancar_faltas_inf '/lancar_faltas_inf', :controller => 'faltas', :action => 'lancar_faltas_inf'
  map.lancar_faltas_infantil '/lancar_faltas_infantil', :controller => 'faltas', :action => 'lancar_faltas_infantil'
  map.lancar_faltas_editar_infantil '/lancar_editar_faltas_infantil', :controller => 'faltas', :action => 'lancar_faltas_editar_infantil'
  map.lancar_notas_alunos_atribuicaos '/lancar_notas_alunos_atribuicaos', :controller => 'atribuicaos', :action => 'lancar_notas_alunos_atribuicao'
  map.consulta_cadastro_aluno '/consulta_cadastro_aluno', :controller => 'alunos', :action => 'consulta_cadastro_aluno'
  map.atribuicao_lancamentos_notas'/atribuicao_lancamentos_notas', :controller => 'notas', :action => 'atribuicao_lancamentos_notas'
  map.relatorios_observacoes'/relatorios_observacoes', :controller => 'atribucaos', :action => 'relatorios_observacoes'
  map.continuar'/continuar', :controller => 'alunos', :action => 'continuar'
  map.relatorios_faltas'/relatorios_faltas', :controller => 'aulas_faltas', :action => 'relatorios_faltas'
  map.relatorios_faltas_professor'/relatorios_faltas_professor', :controller => 'aulas_faltas', :action => 'relatorios_faltas_professor'
  map.relatorios_faltas_funcionario'/relatorios_faltas_funcionario', :controller => 'aulas_faltas', :action => 'relatorios_faltas_funcionario'
  map.relatorios_eventual_professor'/relatorios_eventual_professor', :controller => 'aulas_eventuals', :action => 'relatorios_eventual_professor'
  map.relatorios_eventuals'/relatorios_eventuals', :controller => 'aulas_eventuals', :action => 'relatorios_eventuals'

  map.historico_aviso '/historico_aviso', :controller => 'notas', :action => 'aviso'

  map.edit_status '/edit_status', :controller => 'matriculas', :action => 'edit_status'
  map.matriculas_saidas '/matriculas_saidas', :controller => 'matriculas', :action => 'matriculas_saidas'
  map.matriculas_saidas_seduc '/matriculas_saidas_seduc', :controller => 'matriculas', :action => 'matriculas_saidas_seduc'
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
