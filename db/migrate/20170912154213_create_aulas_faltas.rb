class CreateAulasFaltas < ActiveRecord::Migration
  def self.up
    create_table :aulas_faltas do |t|
      t.references :professor
      t.references :funcionario
      t.references :unidade
      t.string :funcao
      t.string :periodo
      t.date :data
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :aulas_faltas
  end
end
