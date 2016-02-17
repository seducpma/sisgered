class CreateProfessorsClasses < ActiveRecord::Migration
  def self.up
    create_table :professors_classes do |t|
      t.references :classe_id
      t.references :professor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :professors_classes
  end
end
