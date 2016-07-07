class Matricula < ActiveRecord::Base
  belongs_to :classe_id
  belongs_to :aluno_id
  belongs_to :unidade_id
  belongs_to :transf_unidade_id
  belongs_to :rem_classe_id
end
