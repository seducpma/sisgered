class CreateAtribuicaos < ActiveRecord::Migration
  def self.up
    create_table :atribuicaos do |t|
      t.references :classe_id
      t.references :professor_id
      t.string :disciplina
      t.integer :ano_letivo

      t.timestamps
    end
  end

  def self.down
    drop_table :atribuicaos
  end
end
