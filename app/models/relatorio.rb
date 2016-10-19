class Relatorio < ActiveRecord::Base
  
  belongs_to :aluno
  belongs_to :professor
  belongs_to :atribuicao


  validates_length_of :observacao, :in => 0..900

end
