class Relatorio < ActiveRecord::Base
  
  belongs_to :aluno
  belongs_to :professor
  belongs_to :atribuicao


  

end
