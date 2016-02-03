class Unidade < ActiveRecord::Base
  belongs_to :tipo
  belongs_to :regiao
  has_many :professors
  has_many :alunos
  has_many :saude
  has_many :socioeconomicos
  has_many :classes
end
