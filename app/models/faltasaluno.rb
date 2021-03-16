class Faltasaluno < ActiveRecord::Base
  belongs_to :aluno
  belongs_to :matricula
  belongs_to :atribuicao
  belongs_to :professor
  belongs_to :unidade
  belongs_to :disciplina
  belongs_to :user
end
