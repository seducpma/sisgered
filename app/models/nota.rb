class Nota < ActiveRecord::Base
  
  belongs_to :atribuicao
  belongs_to :professor
  belongs_to :aluno
end
