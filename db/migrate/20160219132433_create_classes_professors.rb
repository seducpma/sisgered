class CreateClassesProfessors < ActiveRecord::Migration
  def self.up
    create_table :classes_professors do |t|
      t.references :classe_id
      t.references :professor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :classes_professors
  end
end
