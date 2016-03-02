class Atribuicao < ActiveRecord::Base
  belongs_to :discipĺina
  belongs_to :classe
  belongs_to :professor



   before_save :atribui

  HORARIO = %w(--Selecionar-- MATUTINO VESPERTINO NOTURNO INTEGRAL)








  def atribui

    self.ano_letivo = Time.now.year

  end


end
