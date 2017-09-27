class Funcionario < ActiveRecord::Base
  belongs_to :unidade
  has_many :aulas_faltas

before_save  :maiusculo


 def maiusculo
    self.nome.upcase!


    if  !self.endereco.nil?
          self.endereco.upcase!
    end
    if  !self.complemento.nil?
          self.complemento.upcase!
    end
    if  !self.cidade.nil?
          self.cidade.upcase!
    end
    if  !self.bairro.nil?
          self.bairro.upcase!
    end
    if  !self.funcao.nil?
         self.funcao.upcase!
    end
    if  !self.setor.nil?
          self.setor.upcase!
    end
    if  !self.obs.nil?
          self.obs.upcase!
    end


  end

end
