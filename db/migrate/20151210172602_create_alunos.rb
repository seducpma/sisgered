class CreateAlunos < ActiveRecord::Migration
  def self.up
    create_table :alunos do |t|
      t.references :aluno_pessoa
      t.string :aluno_inep
      t.string :aluno_rm
      t.string :aluno_ra
      t.string :aluno_nis
      t.string :aluno_sus
      t.string :aluno_reside_com
      t.references :aluno_pai
      t.references :aluno_mae
      t.references :aluno_responsavel
      t.string :aluno_resticao
      t.string :aluno_bolsa_familia
      t.string :aluno_imagem
      t.string :aluno_vai_embora_so
      t.string :aluno_acompanhante
      t.string :aluno_aut_passeio
      t.string :aluno_aut_ativ_fisica
      t.string :aluno_atu_ativ_extraclasse
      t.string :aluno_brasil_carinho
      t.string :aluno_renda_cidada
      t.references :aluno_contato1
      t.references :aluno_contato_2
      t.string :aluno_obs

      t.timestamps
    end
  end

  def self.down
    drop_table :alunos
  end
end
