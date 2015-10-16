class Crianca < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :regiao
  belongs_to :unidade


  def before_save
    self.nome.upcase!
    self.bairro.upcase!
    self.complemento.upcase!
    self.mae.upcase!
    self.endereco.upcase!
    self.responsavel_n.upcase!
    self.parentesco.upcase!
    self.local_trabalho.upcase!
    self.servidor_local.upcase!
  end
end
