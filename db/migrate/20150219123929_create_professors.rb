class CreateProfessors < ActiveRecord::Migration
  def self.up
    create_table :professors do |t|
      t.integer :matricula, :null => false
      t.string :nome, :null => false
      t.datetime :dt_atual
      t.datetime :dt_ingresso
      t.datetime :dt_nasc
      t.string :RG, :default => 0
      t.string :CPF, :default => 0
      t.integer :INEP, :default => 0
      t.integer :RD, :default => 0
      t.integer :n_filhos, :default => 0
      t.references :sede_id, :null => false
      t.string :funcao, :null => false
      t.string :funcao2
      t.string :enderes
      t.string :complemento
      t.integer :num
      t.string :telefone
      t.string :cidade
      t.string :obs
      t.decimal :total_trabalhado, :default => 0
      t.decimal :total_titulacao, :default => 0
      t.decimal :pontuacao_final, :default => 0
      t.integer :flag
      t.references :sede_id_ant
      t.string :log_user
      t.integer :prioridade
      t.integer :titulo_arrumado
      t.integer :entrada_concurso
      t.integer :excluido
      t.datetime :data_exclusao
      t.string :motivo
      t.string :cep
      t.string :cel
      t.string :email

      t.timestamps
    end
  end



      create_table :professors do |t|
      t.integer :matricula, :null => false
      t.string :nome, :null => false
      t.datetime :dt_atual
      t.datetime :dt_ingresso
      t.datetime :dt_nasc
      t.string :RG, :default => 0
      t.string :CPF, :default => 0
      t.integer :INEP, :default => 0
      t.integer :RD, :default => 0
      t.integer :n_filhos, :default => 0
      t.references :sede, :null => false
      t.integer :jornada_sem, :default => 0
      t.string :funcao, :null => false
      t.string :endres
      t.string :complemento
      t.string :bairro
      t.integer :num
      t.integer :telefone
      t.string :cidade
      t.string :obs
      t.decimal :total_trabalhado, :default => 0, :precision => ('10,3')
      t.decimal :total_titulacao, :default => 0, :precision => ('10,3')
      t.decimal :pontuacao_final, :default => 0, :precision => ('10,3')
      t.integer :flag
      t.integer :sede_id_ant
      t.string :log_user
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamps



  def self.down
    drop_table :professors
  end
end
