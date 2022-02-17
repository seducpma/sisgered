class CreateRegistros < ActiveRecord::Migration
  def self.up
    create_table :registros do |t|
      t.references :classe
      t.references :professor
      t.references :atribuicao
      t.references :disciplina
      t.references :unidade
      t.references :user
      t.string :conteudo
      t.integer :ano_letivo
      t.datetime :inicio
      t.datetame :fim
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :registros
  end
end
