class CreatePessoas < ActiveRecord::Migration
  def self.up
    create_table :pessoas do |t|
      t.string :pessoa_tipo
      t.string :pessoa_nome
      t.string :pessoa_sexo
      t.date :pessoa_nascimento
      t.string :pessoa_naturalidade
      t.string :pessoa_nacionalidade
      t.date :pessoa_chegada_brasil
      t.string :pessoa_RG
      t.string :pessoa_emissaoRG
      t.string :pessoa_CPF
      t.string :pessoa_emissaoCPF
      t.string :pessoa_estado_civil
      t.string :pessoa_pai
      t.string :pessoa_fone_pai
      t.string :pessoa_email_pai
      t.string :pessoa_mae
      t.string :pessoa_fone_mae
      t.string :pessoa_email_mae
      t.string :pessoa_endereco
      t.string :pessoa_num
      t.string :pessoa_complemento
      t.string :pessoa_cep
      t.string :pessoa_bairro
      t.string :pessoa_cidade
      t.string :pessoa_fone_fixo
      t.string :pessoa_fone_cel
      t.string :pessoa_escolaridade
      t.string :pessoa_profissao
      t.string :pessoa_condicao_profissao
      t.string :pessoa_local_trabalho
      t.string :pessoa_fone_trabalho
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas
  end
end
