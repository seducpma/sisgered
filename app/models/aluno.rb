class Aluno < ActiveRecord::Base
  belongs_to :unidade
  has_many :saudes
  has_many :socioeconomicos
  has_and_belongs_to_many :classes
  has_and_belongs_to_many :notas


  before_save  :maiusculo
  before_save  :atribui_dados
 


  def atribui_dados
    
    self.unidade_id = User.current.unidade_id

  
  end

    def maiusculo
    self.aluno_especial.upcase!
    self.aluno_nome.upcase!

    self.aluno_emissaoRG.upcase!
    if  !self.aluno_emissaoCPF.nil?
          self.aluno_emissaoCPF.upcase!
    end  
    if  !self.aluno_pai.nil?
          self.aluno_pai.upcase!
    end
    if  !self.aluno_endereco_pai.nil?
          self.aluno_endereco_pai.upcase!
    end
    if  !self.aluno_cidade_pai.nil?
          self.aluno_cidade_pai.upcase!
    end
    if  !self.aluno_mae.nil?
         self.aluno_mae.upcase!
    end
    if  !self.aluno_endereco_mae.nil?
          self.aluno_endereco_mae.upcase!
    end
    if  !self.aluno_cidade_mae.nil?
          self.aluno_cidade_mae.upcase!
    end
    if !self.aluno_responsavel.nil?
       self.aluno_responsavel.upcase!
    end
    if  !self.aluno_endereco_responsavel.nil?
          self.aluno_endereco_responsavel.upcase!
    end
    if  !self.aluno_cidade_responsavel.nil?
          self.aluno_cidade_responsavel.upcase!
    end


    if  !self.aluno_endereco_mae.nil?
          self.aluno_endereco_mae.upcase!
    end
    if  !self.aluno_cidade_mae.nil?
          self.aluno_cidade_mae.upcase!
    end
    if  !self.aluno_endereco.nil?
          self.aluno_endereco.upcase!
    end
    if  !self.aluno_cidade.nil?
          self.aluno_cidade.upcase!
    end
    self.aluno_bairro.upcase!
    if  !self.aluno_complemento.nil?
       self.aluno_complemento.upcase!
    end
    self.aluno_nome_beneficiario.upcase!
    self.aluno_acompanhante.upcase!
    if  !self.aluno_obs.nil?
      self.aluno_obs.upcase!
    end
  end


end
