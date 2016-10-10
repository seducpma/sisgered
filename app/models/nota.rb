class Nota < ActiveRecord::Base
  belongs_to :unidade
  belongs_to :atribuicao
  belongs_to :professor
  belongs_to :aluno
  belongs_to :disciplina
  has_many :observacao_notas
  belongs_to :matricula


 
 NOTASB =%w(SN 10.0 9.0 8.0 7.0 6.0 5.0 4.0 3.0 2.0 1.0 0.0 TR RM F NF ABN)



 
end
