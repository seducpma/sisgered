class Conteudo < ActiveRecord::Base
  belongs_to :classe_id
  belongs_to :professor_id
  belongs_to :atribuicao_id
end
