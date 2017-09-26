class CreateObservacaoHistoricos < ActiveRecord::Migration
  def self.up
    create_table :observacao_historicos do |t|
      t.references :aluno_id
      t.string :observacao
      t.integer :ano_letivo

      t.timestamps
    end
  end

  def self.down
    drop_table :observacao_historicos
  end
end
