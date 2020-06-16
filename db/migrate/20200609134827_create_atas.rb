class CreateAtas < ActiveRecord::Migration
  def self.up
    create_table :atas do |t|
      t.string :titulo
      t.references :unidade
      t.text :ata
      t.date :data
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :atas
  end
end
