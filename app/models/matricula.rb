class Matricula < ActiveRecord::Base
  belongs_to :classe
  belongs_to :aluno
  belongs_to :unidade
  belongs_to :transf_unidade
  belongs_to :rem_classe
  has_many :notas


  before_save :caps_look

  def caps_look
    if !self.procedencia.nil?
      self.procedencia.upcase!
    end
    if !self.para.nil?
      self.para.upcase!
    end
   
  end



end