class Falta < ActiveRecord::Base
  belongs_to :aluno
  belongs_to :matricula
  belongs_to :atribuicao
  belongs_to :professor
  belongs_to :unidade

  
validates_presence_of :ano_letivo


end
