class Conteudo < ActiveRecord::Base
 belongs_to :atribuicao
 belongs_to :disciplina
 belongs_to :professor
 belongs_to :unidade
 belongs_to :classe
 
end

