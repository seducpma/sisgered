class Aluno < ActiveRecord::Base
  belongs_to :pessoa
  belongs_to :unidade
  has_and_belongs_to_many :classes


  before_save  :maiusculo
  before_save  :atribui_dados
 


  def atribui_dados
    
    self.unidade_id = User.current.unidade_id
    self.aluno_nome = Pessoa.find(self.pessoa_id).pessoa_nome


  
  end

    def maiusculo
    self.aluno_especial.upcase!
    self.aluno_nome_beneficiario.upcase!
    self.aluno_acompanhante.upcase!
  
  end


end
