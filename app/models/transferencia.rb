class Transferencia < ActiveRecord::Base
   belongs_to :aluno
   belongs_to :unidade
   belongs_to :classe
   before_save :atribui

   def atribui
    self.unidade_id = User.current.unidade_id
    self.ano_letivo = Time.now.year
  end
end
