class CreateUnidades < ActiveRecord::Migration
  def self.up
    create_table :unidades do |t|
      t.references :tipo_id
      t.references :regiao_id
      t.string :nome
      t.string :endereco
      t.string :num
      t.string :CEP
      t.string :bairro
      t.string :cidade
      t.string :fone
      t.string :email
      t.string :diretor
      t.string :coordenador
      t.string :obs
      t.integer :estagiarioM
      t.integer :estagiarioV
      t.integer :estagiarioN
      t.integer :estagiarioE
      t.string :ip
      t.string :biblioteca
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :unidades
  end
end
