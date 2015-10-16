class CreateFinanceiros < ActiveRecord::Migration
  def self.up
    create_table :financeiros do |t|
      t.references :unidade
      t.datetime :data
      t.string :descricao
      t.decimal :credito,  :default => 0
      t.decimal :debito,  :default => 0
      t.string :obs
      t.string :horario
      t.time :horarioe
      t.time :horarios
      t.decimal :vhora
      t.decimal :vkm
      t.decimal :km,  :default => 0
      t.decimal :horas,

      t.timestamps
    end
  end

  def self.down
    drop_table :financeiros
  end
end
