class Atribuicao < ActiveRecord::Base
  belongs_to :disciplina
  belongs_to :classe
  belongs_to :professor
  has_many :notas
  has_many :relatorios
  has_many :conteudos
  has_many :atividade_validacaos
  before_save :atribui

    validates_presence_of :classe_id
    validates_presence_of :professor_id
    #validates_presence_of :disciplina_id

  HORARIO = %w(--Selecionar-- MATUTINO VESPERTINO NOTURNO INTEGRAL)


  def atribui
    self.ano_letivo = Time.now.year
  end


end
