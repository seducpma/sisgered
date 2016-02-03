class CreateSaudes < ActiveRecord::Migration
  def self.up
    create_table :saudes do |t|
      t.references :aluno_id
      t.string :saude_plano_saude
      t.string :saude_cartao_sus
      t.string :saude_necessidade_especial
      t.string :saude_tipo_sangue
      t.string :saude_hab_motora
      t.string :saude_fumante
      t.string :saude_antecedentes_mae
      t.string :saude_parto
      t.string :saude_alimentacao
      t.string :saude_sono
      t.string :saude_neuropsico
      t.string :saude_medicamento
      t.string :saude_antipiretico
      t.string :saude_pelicilina
      t.string :saude_alergia
      t.string :saude_cirurgia
      t.string :saude_fratura
      t.string :saude_probl_visao
      t.string :saude_hospitalizado
      t.string :saude_doenças
      t.string :saude_antecedentes_familia
      t.string :saude_doenças
      t.string :saude_antecedentes_familia
      t.string :saude_fumante_casa
      t.string :saude_dependetes_quimicos
      t.string :saude_obs

      t.timestamps
    end
  end

  def self.down
    drop_table :saudes
  end
end
