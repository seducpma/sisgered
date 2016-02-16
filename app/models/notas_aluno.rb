class NotasAluno < ActiveRecord::Base
  belongs_to :nota_id
  belongs_to :aluno_id
end
