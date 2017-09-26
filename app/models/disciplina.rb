class Disciplina < ActiveRecord::Base
  has_many :atribuicaos
  has_many :notas
   before_save :caps_look

    def caps_look
    if  !self.disciplina.nil?
          self.disciplina.upcase!
    end

  end


end
