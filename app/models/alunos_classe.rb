class AlunosClasse < ActiveRecord::Base
  belongs_to :classe, :dependent => :destroy
  belongs_to :aluno, :dependent => :destroy
end
