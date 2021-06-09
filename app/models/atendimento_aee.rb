class AtendimentoAee < ActiveRecord::Base
  belongs_to :classe
  belongs_to :aluno
  belongs_to :unidade
 



end
