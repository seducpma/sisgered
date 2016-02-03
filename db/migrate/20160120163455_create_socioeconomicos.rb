class CreateSocioeconomicos < ActiveRecord::Migration
  def self.up
    create_table :socioeconomicos do |t|
      t.references :pessoa_id
      t.string :economico_casa
      t.string :economico_tipo_casa
      t.integer :economico_comodos
      t.string :economico_eletricidade
      t.string :economico_esgoto
      t.string :economico_agua
      t.integer :economico_residentes
      t.string :economico_irmaos
      t.string :economico_religao
      t.integer :economico_remunerada
      t.string :economico_renda_familiar
      t.integer :economico_menores
      t.string :economico_carro
      t.string :economico_computador
      t.string :economico_moto
      t.string :economico_geladeira
      t.string :economico_frezer
      t.string :economico_tv
      t.string :economico_internet
      t.string :economico_obs

      t.timestamps
    end
  end

  def self.down
    drop_table :socioeconomicos
  end
end
