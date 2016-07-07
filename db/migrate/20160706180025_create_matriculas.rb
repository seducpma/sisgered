class CreateMatriculas < ActiveRecord::Migration
  def self.up
    create_table :matriculas do |t|
      t.references :classe_id
      t.references :aluno_id
      t.date :ano_letico
      t.string :status
      t.references :unidade_id
      t.string :procedencia
      t.references :transf_unidade_id
      t.string :para
      t.references :rem_classe_id
      t.date :data_transferencia
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :matriculas
  end
end
