class AlunosClasse < ActiveRecord::Base
  belongs_to :classe
  belongs_to :aluno
end
