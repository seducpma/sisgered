class CreateUfaltas < ActiveRecord::Migration
  def self.up
    create_table :ufaltas do |t|
      t.date :data
      t.references :unidade
      t.string :funcao
      t.integer :locados
      t.integer :trabalhando
      t.integer :greve
      t.integer :atestado_dia
      t.integer :atestado_horas
      t.integer :atestado_periodo
      t.integer :atestado_acompanhante
      t.string :quem
      t.integer :total_trab
      t.integer :total_lhando
      t.integer :total_greve
      t.integer :total_atestado_dia
      t.integer :total_atestado_hora
      t.integer :total_atestado_periodo
      t.integer :total_atestado_acompanhante
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :ufaltas
  end
end
