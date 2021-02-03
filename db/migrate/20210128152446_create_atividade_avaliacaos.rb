class CreateAtividadeAvaliacaos < ActiveRecord::Migration
  def self.up
    create_table :atividade_avaliacaos do |t|
      t.references :atividade_id
      t.references :classe_id
      t.references :professor_id
      t.references :atribuicao_id
      t.references :disciplina_id
      t.references :unidade_id
      t.references :user_id
      t.string :avaliacao
      t.date :ano_letivo
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :atividade_avaliacaos
  end
end
