class Conteudo < ActiveRecord::Base
 belongs_to :atribuicao
 belongs_to :disciplina
 belongs_to :professor
 belongs_to :unidade
 belongs_to :classe



 validates_presence_of :classe_id
 validates_presence_of :professor_id
 validates_presence_of :unidade_id
    validates_presence_of :atribuicao_id
 
end

