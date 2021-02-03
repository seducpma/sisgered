class AtividadeAvaliacao < ActiveRecord::Base
  belongs_to :atividade
  belongs_to :classe
  belongs_to :professr
  belongs_to :atribuicao
  belongs_to :disciplina
  belongs_to :unidade
  belongs_to :user
  belongs_to :aluno
  belongs_to :matricula
end
