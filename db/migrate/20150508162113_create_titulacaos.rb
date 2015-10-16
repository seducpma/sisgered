class CreateTitulacaos < ActiveRecord::Migration
  def self.up
    create_table :titulacaos do |t|
      t.string :tipo
      t.string :descricao
      t.string :referencia
      t.integer :valor

      t.timestamps
    end
  end

  def self.down
    drop_table :titulacaos
  end
end
