class Classe < ActiveRecord::Base
  belongs_to :professor
  belongs_to :unidade
  has_and_belongs_to_many :alunos

   before_save :caps_look
   before_save :atribui_unidade

    def caps_look
      if !self.classe_descricao.nil?
         self.classe_descricao.upcase!
      end
      self.classe_classe.upcase!
    end

  before_save  :atribui_unidade



  def atribui_unidade

    self.unidade_id = User.current.unidade_id

    self.classe_ano_letivo = Time.now.year

  end

end
