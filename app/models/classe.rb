class Classe < ActiveRecord::Base

  has_many :matriculas
  belongs_to :unidade
  has_and_belongs_to_many :alunos
  has_many :atribuicaos
  has_many :transferencias

  before_save :caps_look
  before_save :atribui_unidade

  #validates_presence_of :classe_classe

  HORARIO = %w(--Selecionar-- MATUTINO VESPERTINO NOTURNO INTEGRAL)

  def caps_look
    if !self.classe_descricao.nil?
      self.classe_descricao.upcase!
    end
    if  !self.classe_classe.nil?
          self.classe_classe.upcase!
    end

  end


  def atribui_unidade
    self.unidade_id = User.current.unidade_id
  end

end
