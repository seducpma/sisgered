class CreateRelatorios < ActiveRecord::Migration
  def self.up
    create_table :relatorios do |t|
      t.references :aluno_id
      t.references :professor_id
      t.references :atribuicao_id
      t.string :observacao
      t.integer :ano_letivo

      t.timestamps
    end
  end

  def self.down
    drop_table :relatorios
  end
end
