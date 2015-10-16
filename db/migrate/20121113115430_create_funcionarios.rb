class CreateFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :funcionarios do |t|
      t.string :nome
      t.string :apelido
      t.datetime :nascimento
      t.string :sexo
      t.string :cargo
      t.datetime :contratacao
      t.boolean    :em_atividade, :default => 0
      t.datetime :demissao
      t.string :estado_civil
      t.string :conjuge
      t.string :filhos
      t.string :participante
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
      t.string :escolaridade
      t.string :obs
      t.references :unidade
      


      t.timestamps
    end
  end

  def self.down
    drop_table :funcionarios
  end
end
