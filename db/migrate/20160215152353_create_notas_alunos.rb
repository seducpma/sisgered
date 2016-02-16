class CreateNotasAlunos < ActiveRecord::Migration
  def self.up
    create_table :notas_alunos do |t|
      t.references :nota_id
      t.references :aluno_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notas_alunos
  end
end
