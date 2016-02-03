class CreateProfessors < ActiveRecord::Migration
  def self.up
    create_table :professors do |t|
      t.integer :matricula
      t.string :nome
      t.datetime :dt_atual
      t.datetime :dt_ingresso
      t.datetime :dt_nasc
      t.string :RG
      t.string :CPF
      t.integer :INEP
      t.integer :RD
      t.integer :n_filhos
      t.references :sede_id
      t.integer :jornada_sem
      t.string :funcao
      t.string :funcao2
      t.string :endres
      t.string :complemento
      t.string :bairro
      t.string :num
      t.string :telefone
      t.string :cel
      t.string :cidade
      t.string :cep
      t.string :email
      t.string :obs
      t.integer :total_trabalhado
      t.integer :total_titulacao
      t.integer :pontuacao_final
      t.integer :flag
      t.integer :sede_id_ant
      t.string :log_user
      t.integer :prioridade
      t.integer :titulo_arrumado
      t.string :entrada_concurso
      t.integer :desligado
      t.datetime :data_desligado
      t.string :motivo

      t.timestamps
    end
  end

  def self.down
    drop_table :professors
  end
end
