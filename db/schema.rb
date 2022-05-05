# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20220217092916) do

  create_table "acompanhamento_despachos", :force => true do |t|
    t.integer  "acompanhamento_id"
    t.string   "despacho",          :limit => 600
    t.datetime "data"
    t.string   "funcionario"
    t.string   "obs"
    t.string   "aceite",                           :default => "RECUSADO"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acompanhamentos", :force => true do |t|
    t.string   "codigo"
    t.string   "crianca"
    t.string   "RA",             :limit => 20
    t.string   "inscricao"
    t.string   "mae"
    t.string   "responsavel"
    t.datetime "nascimento"
    t.string   "endereco"
    t.integer  "num"
    t.string   "complemento"
    t.string   "cep"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "fone"
    t.string   "fone1"
    t.string   "cel"
    t.string   "email"
    t.string   "assunto",        :limit => 600
    t.integer  "encerrado",                     :default => 0
    t.datetime "data_encerrado"
    t.string   "obs"
    t.string   "funcionario"
    t.string   "solicitante"
    t.string   "por",            :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "administracaos", :force => true do |t|
    t.integer  "unidade_id",       :null => false
    t.integer  "tipo_controle_id"
    t.string   "servidor"
    t.string   "rede"
    t.string   "internet"
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agendas", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "estagiario_id"
    t.date     "data"
    t.time     "horai"
    t.time     "horaf"
    t.string   "solicitante",   :limit => 100
    t.string   "proposito",     :limit => 200
    t.string   "obs",           :limit => 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alunos", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "aluno_status",                         :limit => 15,  :default => "SEM_MATRICULA"
    t.string   "aluno_nome",                           :limit => 260
    t.string   "aluno_sexo",                           :limit => 10
    t.date     "aluno_nascimento"
    t.string   "aluno_certidao_nascimento",            :limit => 50
    t.string   "aluno_livro",                          :limit => 50
    t.string   "aluno_folha",                          :limit => 50
    t.string   "aluno_naturalidade",                   :limit => 200
    t.string   "aluno_nacionalidade",                  :limit => 200
    t.date     "aluno_chegada_brasil"
    t.string   "aluno_RNE",                            :limit => 20
    t.string   "aluno_classificacao",                  :limit => 20
    t.date     "aluno_validade_estrangeiro"
    t.string   "aluno_RG",                             :limit => 15
    t.string   "aluno_emissaoRG",                      :limit => 100
    t.string   "aluno_CPF",                            :limit => 15
    t.string   "aluno_emissaoCPF",                     :limit => 100
    t.string   "aluno_conjuge",                        :limit => 100
    t.string   "aluno_pai",                            :limit => 200
    t.string   "aluno_fone_pai",                       :limit => 50
    t.string   "aluno_email_pai",                      :limit => 80
    t.string   "aluno_endereco_pai",                   :limit => 200
    t.string   "aluno_cidade_pai",                     :limit => 200
    t.string   "aluno_mae",                            :limit => 200
    t.string   "aluno_fone_mae",                       :limit => 50
    t.string   "aluno_email_mae",                      :limit => 80
    t.string   "aluno_endereco_mae",                   :limit => 200
    t.string   "aluno_cidade_mae",                     :limit => 200
    t.string   "aluno_responsavel",                    :limit => 200
    t.string   "aluno_parente",                        :limit => 12
    t.string   "aluno_fone_responsavel",               :limit => 50
    t.string   "aluno_email_responsavel",              :limit => 80
    t.string   "aluno_endereco_responsavel",           :limit => 200
    t.string   "aluno_cidade_responsavel",             :limit => 200
    t.string   "aluno_restricao",                      :limit => 200
    t.string   "aluno_reside_com",                     :limit => 200
    t.string   "aluno_endereco",                       :limit => 200
    t.string   "aluno_num",                            :limit => 10
    t.string   "aluno_complemento",                    :limit => 200
    t.string   "aluno_cep",                            :limit => 12
    t.string   "aluno_bairro",                         :limit => 200
    t.string   "aluno_cidade",                         :limit => 200
    t.string   "aluno_fone_fixo",                      :limit => 40
    t.string   "aluno_fone_cel",                       :limit => 40
    t.string   "aluno_email",                          :limit => 200
    t.integer  "aluno_inep"
    t.string   "aluno_rm",                             :limit => 15
    t.string   "aluno_ra",                             :limit => 15
    t.integer  "aluno_nis"
    t.string   "aluno_bolsa_familia",                  :limit => 3
    t.string   "aluno_especial",                       :limit => 200
    t.string   "aluno_nome_beneficiario",              :limit => 150
    t.string   "aluno_profissao_responsavel",          :limit => 50
    t.string   "aluno_nome_responsavel",               :limit => 200
    t.string   "aluno_parente_responsavel",            :limit => 20
    t.string   "aluno_condicao_profissao_responsavel", :limit => 50
    t.string   "aluno_local_trabalho_responsavel",     :limit => 200
    t.string   "aluno_endereco_trabalho_responsavel",  :limit => 200
    t.string   "aluno_fone_trabalho_responsavel",      :limit => 50
    t.string   "aluno_contato1",                       :limit => 200
    t.string   "aluno_contato1_fone",                  :limit => 50
    t.string   "aluno_contato2",                       :limit => 200
    t.string   "aluno_contato2_fone",                  :limit => 50
    t.string   "aluno_contato3",                       :limit => 200
    t.string   "aluno_contato3_fone",                  :limit => 50
    t.string   "aluno_contato4",                       :limit => 200
    t.string   "aluno_contato4_fone",                  :limit => 50
    t.string   "aluno_contato5",                       :limit => 200
    t.string   "aluno_contato5_fone",                  :limit => 50
    t.string   "aluno_contato6",                       :limit => 200
    t.string   "aluno_contato6_fone",                  :limit => 50
    t.string   "aluno_autoriza_imagem",                :limit => 3
    t.string   "aluno_vai_embora_so",                  :limit => 3
    t.string   "aluno_vai_embora",                     :limit => 3
    t.string   "aluno_acompanhante",                   :limit => 200
    t.string   "aluno_autoriza_passeio",               :limit => 3
    t.string   "aluno_autoriza_ativ_fisica",           :limit => 3
    t.string   "aluno_autoriza_ativ_extraclasse",      :limit => 3
    t.string   "aluno_brasil_carinhoso",               :limit => 3
    t.string   "aluno_emergencial",                    :limit => 3
    t.string   "aluno_odontologico",                   :limit => 3
    t.string   "aluno_fluor",                          :limit => 3
    t.string   "aluno_renda_cidada",                   :limit => 3
    t.string   "aluno_obs"
    t.integer  "trans_in",                                            :default => 0,               :null => false
    t.integer  "unidade_anterior"
    t.datetime "transferido"
    t.integer  "mesma_unidade",                                       :default => 0,               :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anexos", :force => true do |t|
    t.string   "titulo"
    t.text     "descricao"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "unidade_id"
  end

  create_table "atas", :force => true do |t|
    t.string   "titulo"
    t.integer  "unidade_id"
    t.string   "moderador",  :limit => 100
    t.string   "secretario", :limit => 100
    t.text     "ata"
    t.integer  "quant"
    t.date     "data"
    t.text     "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "atendimento_aees", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "aluno_id"
    t.integer  "classe_num"
    t.integer  "ano_letivo"
    t.string   "status"
    t.string   "atendimento"
    t.string   "classe_mat"
    t.integer  "unidade_id"
    t.string   "obs",         :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "atividade_avaliacaos", :force => true do |t|
    t.integer  "atividade_id"
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "atribuicao_id"
    t.integer  "disciplina_id"
    t.integer  "aluno_id"
    t.integer  "matricula_id"
    t.integer  "unidade_id"
    t.integer  "ano_letivo"
    t.integer  "user_id"
    t.string   "avaliacao",     :limit => 50
    t.string   "devolutiva",    :limit => 20
    t.string   "nota",          :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "atividades", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "atribuicao_id"
    t.integer  "disciplina_id"
    t.integer  "unidade_id"
    t.integer  "user_id"
    t.string   "atividade",     :limit => 50
    t.string   "componente",    :limit => 50
    t.integer  "ano_letivo"
    t.string   "descricao",     :limit => 100
    t.date     "inicio"
    t.date     "fim"
    t.string   "obs",           :limit => 100
    t.string   "tipo",          :limit => 10
    t.integer  "avaliativa",                   :default => 0, :null => false
    t.string   "validado_por",  :limit => 100
    t.datetime "validado_em"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "atribuicaos", :force => true do |t|
    t.integer  "classe_id",                                  :null => false
    t.integer  "professor_id",                               :null => false
    t.integer  "disciplina_id"
    t.integer  "ano_letivo",                  :default => 0
    t.integer  "ativo",                       :default => 0, :null => false
    t.integer  "aulas1",                      :default => 0, :null => false
    t.integer  "aulas2",                      :default => 0, :null => false
    t.integer  "aulas3",                      :default => 0, :null => false
    t.integer  "aulas4",                      :default => 0, :null => false
    t.string   "email",         :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aulas_eventuals", :force => true do |t|
    t.integer  "eventual_id"
    t.integer  "unidade_id"
    t.integer  "classe_id"
    t.string   "categoria",   :limit => 20
    t.string   "periodo"
    t.integer  "ano_letivo"
    t.date     "data"
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classes", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "classe_classe",     :limit => 45
    t.string   "classe_descricao",  :limit => 45
    t.string   "sala",              :limit => 10
    t.string   "horario",           :limit => 50
    t.integer  "classe_ano_letivo"
    t.string   "direcao",           :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conteudoprogramaticos", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "atribuicao_id"
    t.integer  "disciplina_id"
    t.integer  "unidade_id"
    t.integer  "user_id"
    t.text     "conteudo"
    t.integer  "ano_letivo"
    t.date     "inicio"
    t.date     "fim",                          :null => false
    t.string   "obs",           :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conteudoprogramaticos1", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "atribuicao_id"
    t.integer  "disciplina_id"
    t.integer  "unidade_id"
    t.integer  "user_id"
    t.text     "conteudo"
    t.integer  "ano_letivo"
    t.date     "inicio"
    t.date     "fim",                          :null => false
    t.string   "obs",           :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conteudos", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "atribuicao_id"
    t.integer  "disciplina_id"
    t.integer  "unidade_id"
    t.integer  "user_id"
    t.text     "conteudo"
    t.integer  "ano_letivo"
    t.date     "inicio"
    t.date     "fim",                          :null => false
    t.string   "obs",           :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disciplinas", :force => true do |t|
    t.string   "disciplina",      :limit => 150
    t.integer  "ordem"
    t.string   "curriculo",       :limit => 1
    t.integer  "ordem_curriculo"
    t.integer  "ano_letivo"
    t.integer  "tipo_un"
    t.integer  "nucleo_comum",                   :default => 0, :null => false
    t.integer  "nao_disciplina",                 :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eventuals", :force => true do |t|
    t.integer  "professor_id"
    t.integer  "unidade_id"
    t.string   "categoria",       :limit => 20
    t.string   "disponibilidade"
    t.string   "periodo",         :limit => 25
    t.string   "contato",         :limit => 200
    t.integer  "ano_letivo"
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faltas", :force => true do |t|
    t.integer  "aluno_id"
    t.integer  "matricula_id"
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "unidade_id"
    t.string   "classe"
    t.integer  "ano_letivo"
    t.integer  "faltas1"
    t.integer  "aulas1"
    t.integer  "freq1"
    t.integer  "faltas2"
    t.integer  "aulas2"
    t.integer  "freq2"
    t.integer  "faltas3"
    t.integer  "aulas3"
    t.integer  "freq3"
    t.integer  "faltas4"
    t.integer  "aulas4"
    t.integer  "freq4"
    t.integer  "faltas5"
    t.integer  "aulas5"
    t.integer  "freq5"
    t.string   "obs"
    t.integer  "ativo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faltasalunos", :force => true do |t|
    t.integer  "aluno_id"
    t.integer  "matricula_id"
    t.integer  "atribuicao_id"
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "unidade_id"
    t.integer  "disciplina_id"
    t.integer  "user_id"
    t.integer  "ano_letivo"
    t.date     "data"
    t.integer  "faltas",        :default => 1
    t.string   "conteudo"
    t.string   "obs"
    t.integer  "ativo",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "informativos", :force => true do |t|
    t.text     "mensagem"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matriculas", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "aluno_id"
    t.integer  "classe_num"
    t.integer  "ano_letivo"
    t.string   "status",             :limit => 14,  :default => "MATRICULADO"
    t.integer  "unidade_id"
    t.string   "procedencia",        :limit => 200
    t.integer  "transf_unidade_id"
    t.string   "para",               :limit => 200
    t.integer  "rem_classe_id"
    t.date     "data_transferencia"
    t.string   "reprovado",          :limit => 1,   :default => "0"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notas", :force => true do |t|
    t.integer  "aluno_id",                                                                     :null => false
    t.integer  "matricula_id"
    t.integer  "atribuicao_id"
    t.integer  "professor_id"
    t.integer  "unidade_id"
    t.integer  "disciplina_id"
    t.integer  "classe"
    t.integer  "ano_letivo",                                                                   :null => false
    t.integer  "bimestre"
    t.string   "nota1",         :limit => 4
    t.integer  "faltas1",                                                     :default => 0,   :null => false
    t.integer  "comp1",                                                       :default => 0,   :null => false
    t.integer  "aulas1",                                                      :default => 0
    t.integer  "freq1",         :limit => 10,  :precision => 10, :scale => 0, :default => 100
    t.string   "nota2",         :limit => 4
    t.integer  "faltas2",                                                     :default => 0,   :null => false
    t.integer  "comp2",                                                       :default => 0
    t.integer  "aulas2",                                                      :default => 0
    t.integer  "freq2",         :limit => 10,  :precision => 10, :scale => 0, :default => 100
    t.string   "nota3",         :limit => 4
    t.integer  "faltas3",                                                     :default => 0,   :null => false
    t.integer  "comp3",                                                       :default => 0,   :null => false
    t.integer  "aulas3",                                                      :default => 0
    t.integer  "freq3",         :limit => 10,  :precision => 10, :scale => 0, :default => 100
    t.string   "nota4",         :limit => 4
    t.integer  "faltas4",                                                     :default => 0,   :null => false
    t.integer  "comp4",                                                       :default => 0,   :null => false
    t.integer  "aulas4",                                                      :default => 0
    t.integer  "freq4",         :limit => 10,  :precision => 10, :scale => 0, :default => 100
    t.string   "nota5",         :limit => 4
    t.integer  "faltas5",                                                     :default => 0,   :null => false
    t.integer  "comp5",                                                       :default => 0,   :null => false
    t.integer  "aulas5",                                                      :default => 0
    t.integer  "freq5",         :limit => 10,  :precision => 10, :scale => 0, :default => 100
    t.string   "escola",        :limit => 200
    t.string   "cidade",        :limit => 200,                                :default => ""
    t.string   "obs1",          :limit => 600
    t.integer  "ativo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observacao_historicos", :force => true do |t|
    t.integer  "aluno_id"
    t.string   "observacao",      :limit => 800
    t.integer  "carga_horaria_b", :limit => 2
    t.integer  "carga_horaria_d", :limit => 2
    t.string   "escola",          :limit => 150
    t.string   "cidade",          :limit => 200
    t.string   "quem",            :limit => 15
    t.date     "data"
    t.integer  "classe"
    t.integer  "ano_letivo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observacao_notas", :force => true do |t|
    t.integer  "nota_id"
    t.integer  "aluno_id"
    t.string   "observacao", :limit => 1400, :null => false
    t.date     "data"
    t.string   "quem",       :limit => 15
    t.integer  "ano_letivo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "professors", :force => true do |t|
    t.integer  "matricula",                                                                          :null => false
    t.string   "nome",                                                                               :null => false
    t.integer  "dt_atual"
    t.datetime "dt_ingresso"
    t.datetime "dt_nasc"
    t.string   "RG",                :limit => 20,                                 :default => "0"
    t.string   "CPF",               :limit => 20,                                 :default => "0"
    t.string   "INEP",              :limit => 20,                                 :default => "0"
    t.integer  "RD",                                                              :default => 0
    t.integer  "n_filhos",                                                        :default => 0
    t.integer  "unidade_id",                                                                         :null => false
    t.integer  "jornada_sem",                                                     :default => 0
    t.string   "funcao",                                                                             :null => false
    t.string   "funcao2"
    t.string   "endres"
    t.string   "complemento"
    t.string   "bairro"
    t.integer  "num"
    t.integer  "telefone"
    t.string   "cel",               :limit => 13,                                                    :null => false
    t.string   "cidade"
    t.string   "cep",               :limit => 11,                                                    :null => false
    t.string   "email",             :limit => 150,                                                   :null => false
    t.string   "obs"
    t.integer  "total_trabalhado",  :limit => 10,  :precision => 10, :scale => 0, :default => 0
    t.integer  "total_titulacao",   :limit => 10,  :precision => 10, :scale => 0, :default => 0
    t.integer  "pontuacao_final",   :limit => 10,  :precision => 10, :scale => 0, :default => 0
    t.integer  "flag",                                                            :default => 0,     :null => false
    t.integer  "sede_id_ant"
    t.string   "log_user",          :limit => 30
    t.integer  "prioridade",                                                      :default => 0,     :null => false
    t.boolean  "temporario",                                                      :default => false
    t.string   "entrada_concurso"
    t.integer  "desligado",         :limit => 1,                                  :default => 0,     :null => false
    t.date     "data_desligado"
    t.string   "motivo",            :limit => 200
    t.integer  "diversas_unidades"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "obs_interno",       :limit => 200
  end

  create_table "registros", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "professor_id"
    t.integer  "atribuicao_id"
    t.integer  "disciplina_id"
    t.integer  "unidade_id"
    t.integer  "user_id"
    t.string   "conteudo"
    t.integer  "ano_letivo"
    t.datetime "inicio"
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relatorios", :force => true do |t|
    t.integer  "aluno_id",                                                                      :null => false
    t.integer  "professor_id"
    t.integer  "atribuicao_id"
    t.string   "profissional",  :limit => 10
    t.text     "observacao"
    t.integer  "ano_letivo"
    t.integer  "dias_letivos",                                               :default => 0
    t.integer  "faltas",                                                     :default => 0
    t.decimal  "frequencia",                  :precision => 10, :scale => 2, :default => 100.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name",      :limit => 30
    t.string "descricao", :limit => 40
  end

  create_table "roles_users", :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "saudes", :force => true do |t|
    t.integer  "aluno_id",                                  :null => false
    t.integer  "unidade_id",                                :null => false
    t.string   "saude_plano_saude",          :limit => 200
    t.string   "saude_cartao_sus",           :limit => 200
    t.string   "saude_necessidade_especial", :limit => 200
    t.string   "saude_tipo_sangue",          :limit => 3
    t.string   "saude_hab_motora",           :limit => 20
    t.string   "saude_fumante",              :limit => 3
    t.string   "saude_antecedentes_mae",     :limit => 100
    t.string   "saude_parto",                :limit => 10
    t.string   "saude_alimentacao",          :limit => 100
    t.string   "saude_intolerancia",         :limit => 200
    t.string   "saude_sono",                 :limit => 12
    t.string   "saude_neuropsico",           :limit => 200
    t.string   "saude_medicamento",          :limit => 200
    t.string   "saude_antipiretico",         :limit => 100
    t.string   "saude_pelicilina",           :limit => 200
    t.string   "saude_alergia",              :limit => 200
    t.string   "saude_cirurgia",             :limit => 200
    t.string   "saude_fratura",              :limit => 200
    t.string   "saude_probl_visao",          :limit => 200
    t.string   "saude_hospitalizado",        :limit => 200
    t.string   "saude_doencas",              :limit => 100
    t.string   "saude_antecedentes_familia", :limit => 200, :null => false
    t.string   "saude_fumante_casa",         :limit => 50
    t.string   "saude_dependetes_quimicos",  :limit => 50
    t.string   "saude_obs",                  :limit => 300
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "situacao_alunos", :force => true do |t|
    t.string "status", :limit => 15
  end

  create_table "socioeconomicos", :force => true do |t|
    t.integer  "aluno_id",                                :null => false
    t.integer  "unidade_id",                              :null => false
    t.string   "economico_casa",           :limit => 10
    t.string   "economico_tipo_casa",      :limit => 15
    t.integer  "economico_comodos"
    t.string   "economico_eletricidade",   :limit => 15
    t.string   "economico_esgoto",         :limit => 15
    t.string   "economico_agua",           :limit => 15
    t.integer  "economico_residentes"
    t.string   "economico_irmaos",         :limit => 200
    t.string   "economico_religiao",       :limit => 50
    t.integer  "economico_remunerada"
    t.string   "economico_renda_familiar", :limit => 50
    t.integer  "economico_menores"
    t.string   "economico_carro",          :limit => 3
    t.string   "economico_computador",     :limit => 3
    t.string   "economico_moto",           :limit => 3
    t.string   "economico_geladeira",      :limit => 3
    t.string   "economico_freezer",        :limit => 3
    t.string   "economico_tv",             :limit => 3
    t.string   "economico_internet",       :limit => 10
    t.string   "economico_lava_roupa",     :limit => 3
    t.string   "economico_obs",            :limit => 300
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "tipos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unidades", :force => true do |t|
    t.integer  "tipo_id"
    t.integer  "regiao_id"
    t.string   "nome"
    t.string   "endereco"
    t.integer  "num"
    t.string   "CEP"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "fone"
    t.string   "email"
    t.string   "diretor"
    t.string   "vice",        :limit => 100
    t.string   "supervisao",  :limit => 100
    t.string   "coordenador"
    t.string   "autorizacao", :limit => 150
    t.date     "publicacao",                                    :null => false
    t.string   "obs"
    t.integer  "estagiarioM",                :default => 0
    t.integer  "estagiarioV",                :default => 0
    t.integer  "estagiarioN",                :default => 0
    t.integer  "estagiarioE",                :default => 0
    t.string   "ip"
    t.string   "biblioteca"
    t.boolean  "status",                     :default => true,  :null => false
    t.boolean  "desativada",                 :default => false, :null => false
    t.integer  "latitude"
    t.integer  "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "unidade_id",                              :default => 0
    t.integer  "professor_id"
    t.string   "layout",                                  :default => "application"
    t.string   "password_reset_code"
    t.datetime "ultimo_acesso"
  end

end
