class CreateRelatorios < ActiveRecord::Migration
  def self.up
    create_table :relatorios do |t|
      t.references :obreiro
      t.references :unidade
      t.datetime :data
      t.string :atividade
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :relatorios
  end
end
