class CreateClasses < ActiveRecord::Migration
  def self.up
    create_table :classes do |t|
      t.string :classe
      t.references :professor_id
      t.references :unidade_id
      t.string :auxiliar
      t.string :estagiario
      t.string :descricao

      t.timestamps
    end
  end

  def self.down
    drop_table :classes
  end
end
