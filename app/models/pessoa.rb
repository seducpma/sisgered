class Pessoa < ActiveRecord::Base

  has_many :alunos
  has_many :saudes
  has_many :socioeconomicos
  
  validates_presence_of :pessoa_nome
  validates_presence_of :pessoa_nome
  before_save  :maiusculo
  before_save  :atribui_unidade



  def atribui_unidade

    self.unidade_id = User.current.unidade_id

  end


  def maiusculo
    self.pessoa_tipo.upcase!
    self.pessoa_nome.upcase!
    self.pessoa_sexo.upcase!
    self.pessoa_naturalidade.upcase!
    self.pessoa_nacionalidade.upcase!
    self.pessoa_emissaoRG.upcase!
    self.pessoa_emissaoCPF.upcase!
    self.pessoa_mae.upcase!
    self.pessoa_pai.upcase!
    self.pessoa_endereco.upcase!
    self.pessoa_complemento.upcase!
    self.pessoa_bairro.upcase!
    self.pessoa_cidade.upcase!

    if (self.pessoa_estado_civil.nil? and self.pessoa_escolaridade.nil?)

    else
        self.pessoa_estado_civil.upcase!
        self.pessoa_escolaridade.upcase!
        self.pessoa_profissao.upcase!
        self.pessoa_local_trabalho.upcase!
        self.pessoa_condicao_profissao.upcase!
  end
    
    
  end



  
end
