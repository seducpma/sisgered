class Atividade < ActiveRecord::Base
  belongs_to :classe_id
  belongs_to :professor_id
  belongs_to :atribuicao_id
  belongs_to :disciplina_id
  belongs_to :unidade_id
  belongs_to :user_id
end
