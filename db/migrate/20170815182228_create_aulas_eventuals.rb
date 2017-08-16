class CreateAulasEventuals < ActiveRecord::Migration
  def self.up
    create_table :aulas_eventuals do |t|
      t.references :eventual
      t.references :unidade
      t.references :classe
      t.string :periodo
      t.integer :ano_letivo
      t.date :data
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :aulas_eventuals
  end
end
