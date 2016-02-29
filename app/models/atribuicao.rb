class Atribuicao < ActiveRecord::Base
  belongs_to :classe
  belongs_to :professor
 before_save :caps_look
   before_save :atribui

  HORARIO = %w(--Selecionar-- MATUTINO VESPERTINO NOTURNO INTEGRAL)


    def caps_look

        self.disciplina.upcase!

    end





  def atribui

    self.ano_letivo = Time.now.year

  end


end
