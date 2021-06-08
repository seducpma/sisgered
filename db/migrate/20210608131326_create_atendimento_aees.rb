class CreateAtendimentoAees < ActiveRecord::Migration
  def self.up
    create_table :atendimento_aees do |t|
      t.references :classe
      t.references :aluno
      t.integer :classe_num
      t.integer :ano_letivo
      t.string :status
      t.refences :unidade
      t.string :atendimento
      t.string :classe_mat

      t.timestamps
    end
  end

  def self.down
    drop_table :atendimento_aees
  end
end
