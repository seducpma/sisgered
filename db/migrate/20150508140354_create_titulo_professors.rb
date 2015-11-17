class CreateTituloProfessors < ActiveRecord::Migration
  def self.up
    create_table :titulo_professors do |t|
      t.references :titulo
      t.references :professor
      t.string :obs
      t.integer :quantidade
      t.integer :pontuacao_titulo
      t.date :dt_titulo
      t.date :dt_validade
      t.boolean :status

      t.timestamps
    end
  end

  def self.down
    drop_table :titulo_professors
  end
end
