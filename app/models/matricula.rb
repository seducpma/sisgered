class Matricula < ActiveRecord::Base
  belongs_to :classe
  belongs_to :aluno
  belongs_to :unidade
  belongs_to :transf_unidade
  belongs_to :rem_classe
  has_many :notas, :dependent => :destroy
  has_many :faltas, :dependent => :destroy
  has_many :atividade_avaliacaos, :dependent => :destroy
  
  validates_presence_of :aluno_id, :classe_id
  

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