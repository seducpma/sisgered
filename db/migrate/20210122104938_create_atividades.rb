class CreateAtividades < ActiveRecord::Migration
  def self.up
    create_table :atividades do |t|
      t.references :classe_id
      t.references :professor_id
      t.references :atribuicao_id
      t.references :disciplina_id
      t.references :unidade_id
      t.references :user_id
      t.string :atividade
      t.date :ano_letivo
      t.string :descricao
      t.date :inicio
      t.date :fim
      t.string :obs
      t.integer :validacao
      t.string :validado_por
      t.date :validado_em

      t.timestamps
    end
  end

  def self.down
    drop_table :atividades
  end
end
