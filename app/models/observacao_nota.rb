class ObservacaoNota < ActiveRecord::Base
  belongs_to :nota
  belongs_to :aluno
end
