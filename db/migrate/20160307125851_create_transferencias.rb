class CreateTransferencias < ActiveRecord::Migration
  def self.up
    create_table :transferencias do |t|
      t.string :de
      t.strind :para
      t.references :aluno_id
      t.integer :ano_letivo

      t.timestamps
    end
  end

  def self.down
    drop_table :transferencias
  end
end
