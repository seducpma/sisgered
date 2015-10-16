class CreateFamiliares < ActiveRecord::Migration
  def self.up
    create_table :familiares do |t|
      t.string :nome
      t.string :parentesco
      t.integer :idade
      t.datetime :nascimento
      t.string :estado_civil
      t.references :funcionario
      
      t.timestamps
    end
  end

  def self.down
    drop_table :familiares
  end
end
