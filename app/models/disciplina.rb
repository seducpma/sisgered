class Disciplina < ActiveRecord::Base
  has_many :atribuicaos
  has_many :notas
end
