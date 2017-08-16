class CreateEventuals < ActiveRecord::Migration
  def self.up
    create_table :eventuals do |t|
      t.references :professor
      t.string :disponibilidade
      t.string :horario
      t.integer :ano_letivo
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :eventuals
  end
end
