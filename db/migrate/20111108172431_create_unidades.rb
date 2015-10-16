class CreateUnidades < ActiveRecord::Migration
  def self.up
    create_table :unidades do |t|
      t.string     :nome
      t.string     :endereco
      t.integer    :num
      t.string     :complemento
      t.string     :bairro
      t.string     :cidade
      t.string     :fone
      t.string     :email
      t.string     :atividade
      t.string     :responsavel1
      t.string     :cargoresp1
      t.string     :foneresp1
      t.string     :emailresp1
      t.string     :responsavel2
      t.string     :cargoresp2
      t.string     :foneresp2
      t.string     :emailresp2
      t.boolean    :em_atividade, :default => 0
      t.datetime   :data_desliga
      t.string     :obs 
      t.references :obreiro


      t.timestamps
    end
  end

  def self.down
    drop_table :unidades
  end
end
