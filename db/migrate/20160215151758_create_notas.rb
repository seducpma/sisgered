class CreateNotas < ActiveRecord::Migration
  def self.up
    create_table :notas do |t|
      t.references :aluno_id
      t.references :unidade_id
      t.references :professor_id
      t.integer :ano_letivo
      t.decimal :nota
      t.integer :faltas
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :notas
  end
end
