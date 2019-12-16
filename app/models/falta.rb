class Falta < ActiveRecord::Base
  
  belongs_to :unidade
  belongs_to :atribuicao
  belongs_to :professor
  belongs_to :aluno
  belongs_to :disciplina
  belongs_to :matricula




end
