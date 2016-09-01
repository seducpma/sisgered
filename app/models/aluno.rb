class Aluno < ActiveRecord::Base
  belongs_to :unidade
  has_many:matriculas
  has_many :saudes
  has_many :socioeconomicos
  has_and_belongs_to_many :classes
  has_many :notas
  has_attached_file :photo, :styles => {:thumb=> "100x100#", :small  => "180x180>" },
                    :url => ":rails_root/photos/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/photos/:id/:style/:basename.:extension"



  before_save  :maiusculo
  before_save  :atribui_dados
 
  validates_presence_of :aluno_nome

  def atribui_dados
    
    self.unidade_id = User.current.unidade_id
    if self.aluno_nacionalidade == 'BRASILEIRO'
       self.aluno_chegada_brasil = nil
       self.aluno_validade_estrangeiro = nil
    end
  
  end

 def maiusculo
    self.aluno_especial.upcase!
    self.aluno_nome.upcase!
     self.aluno_nacionalidade.upcase!

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
   if  !self.aluno_naturalidade.nil?
       self.aluno_naturalidade.upcase!
   end
   if  !self.aluno_profissao_responsavel.nil?
      self.aluno_profissao_responsavel.upcase!
   end
   if  !self.aluno_local_trabalho_responsavel.nil?
      self.aluno_local_trabalho_responsavel.upcase!
   end



  end


end
