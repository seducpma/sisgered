class Crianca < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :regiao
  belongs_to :unidade

  validates_presence_of :unidade_id

 Status = %w(NA_DEMANDA DESISTENTE CANCELADA MATRICULADA)
  def before_save
    self.nome.upcase!
    self.bairro.upcase!
    self.complemento.upcase!
    self.mae.upcase!
    self.necessidade.upcase!
    self.pai.upcase!
    self.endereco.upcase!
    self.responsavel_n.upcase!
    self.parentesco.upcase!
    self.local_trabalho.upcase!
    self.servidor_local.upcase!
    self.nomerecado.upcase!
    self.status.upcase!
  end
end
