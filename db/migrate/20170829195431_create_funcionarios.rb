class CreateFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :funcionarios do |t|
      t.integer :matricula
      t.string :nome
      t.datetime :nascimento
      t.string :endereco
      t.integer :num
      t.string :complemento
      t.string :cep
      t.string :bairro
      t.string :cidade
      t.string :fone
      t.string :cel
      t.string :email
      t.references :unidade
      t.string :funcao
      t.string :setor
      t.string :horario
      t.string :status
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :funcionarios
  end
end
