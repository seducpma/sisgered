class CreateConteudos < ActiveRecord::Migration
  def self.up
    create_table :conteudos do |t|
      t.references :classe_id
      t.references :professor_id
      t.references :atribuicao_id
      t.string :conteudo
      t.integer :ano_letivo
      t.date :inicio
      t.date :fim
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :conteudos
  end
end
