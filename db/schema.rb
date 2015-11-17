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

ActiveRecord::Schema.define(:version => 20130227131932) do

  create_table "familiares", :force => true do |t|
    t.string   "nome"
    t.string   "parentesco"
    t.integer  "idade"
    t.datetime "nascimento"
    t.string   "estado_civil"
    t.integer  "funcionario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "financeiros", :force => true do |t|
    t.integer  "unidade_id"
    t.datetime "data"
    t.integer  "credito",    :limit => 10, :precision => 10, :scale => 0
    t.integer  "debito",     :limit => 10, :precision => 10, :scale => 0
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funcionarios", :force => true do |t|
    t.string   "nome"
    t.string   "apelido"
    t.datetime "nascimento"
    t.string   "sexo"
    t.string   "cargo"
    t.string   "estado_civil"
    t.string   "conjuge"
    t.string   "participante"
    t.string   "igreja"
    t.string   "endereco"
    t.integer  "num"
    t.string   "complemento"
    t.string   "cep"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "fone"
    t.string   "cel"
    t.string   "email"
    t.string   "escolaridade"
    t.string   "obs"
    t.integer  "unidade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "informativos", :force => true do |t|
    t.text     "mensagem"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "acao"
    t.string   "area"
    t.integer  "find_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "obreiros", :force => true do |t|
    t.string   "nome"
    t.string   "apelido"
    t.datetime "nascimento"
    t.string   "estado_civil"
    t.string   "conjuge"
    t.string   "igreja"
    t.string   "endereco"
    t.integer  "num"
    t.string   "complemento"
    t.string   "cep"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "fone"
    t.string   "cel"
    t.string   "email"
    t.string   "formação"
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relatorios", :force => true do |t|
    t.integer  "obreiro_id"
    t.integer  "unidade_id"
    t.datetime "data"
    t.string   "atividade"
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "unidades", :force => true do |t|
    t.string   "nome"
    t.string   "endereco"
    t.integer  "num"
    t.string   "complemento"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "fone"
    t.string   "email"
    t.string   "atividade"
    t.string   "responsavel1"
    t.string   "cargoresp1"
    t.string   "foneresp1"
    t.string   "emailresp1"
    t.string   "responsavel2"
    t.string   "cargoresp2"
    t.string   "foneresp2"
    t.string   "emailresp2"
    t.boolean  "em_atividade", :default => false
    t.datetime "data_desliga"
    t.string   "obs"
    t.integer  "obreiro_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "obreiro_id"
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "password_reset_code"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
