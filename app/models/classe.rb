class Classe < ActiveRecord::Base

  
  belongs_to :unidade
  has_and_belongs_to_many :alunos
  has_many :atribuicaos
  has_many :transferencias

   before_save :caps_look
   before_save :atribui_unidade

  HORARIO = %w(--Selecionar-- MATUTINO VESPERTINO NOTURNO INTEGRAL)


    def caps_look
      if !self.classe_descricao.nil?
         self.classe_descricao.upcase!
      end
      self.classe_classe.upcase!
    end





  def atribui_unidade

    self.unidade_id = User.current.unidade_id

    self.classe_ano_letivo = Time.now.year

  end

end
