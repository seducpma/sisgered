class CreateSituacaoAlunos < ActiveRecord::Migration
  def self.up
    create_table :situacao_alunos do |t|
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :situacao_alunos
  end
end
