class CreateObreiros < ActiveRecord::Migration
  def self.up
    create_table :obreiros do |t|
      t.string :nome
      t.string :apelido
      t.datetime :nascimento
      t.string :estado_civil
      t.string :conjuge
      t.string :igreja
      t.string :endereco
      t.integer :num
      t.string :complemento
      t.string :cep
      t.string :bairro
      t.string :cidade
      t.string :fone
      t.string :cel
      t.string :email
      t.string :formação
      t.string :obs


      t.timestamps
    end
  end

  def self.down
    drop_table :obreiros
  end
end
