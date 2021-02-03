class Atividade < ActiveRecord::Base
  belongs_to :classe
  belongs_to :professor
  belongs_to :atribuicao
  belongs_to :disciplina
  belongs_to :unidade
  belongs_to :user
  has_many :atividade_avaliacaos


 validates_presence_of :disciplina_id
end
