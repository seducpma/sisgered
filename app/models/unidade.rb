class Unidade < ActiveRecord::Base
  belongs_to :tipo
  belongs_to :regiao
  has_many :professors
  has_many :eventuals
  has_many :matriculas
  has_many :alunos
  has_many :saude
  has_many :socioeconomicos
  has_many :classes
  has_many :transferencias
  has_many :notas
end
