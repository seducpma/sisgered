class Aluno < ActiveRecord::Base
  belongs_to :unidade
  has_many:matriculas
  has_many :saudes
  has_many :socioeconomicos
  has_many :observacao_historicos
  has_many :observacao_notas
  has_many :relatorios
  has_and_belongs_to_many :classes
  has_many :notas
  has_many :atividade_avaliacaos
   
  has_attached_file :photo, :styles => {:original=> "180x180>" },
                    :url => "/photos/:class/:id.:extension",
                    :path => ":rails_root/public/photos/:class/:id.:extension"


  before_save  :maiusculo

 
  validates_presence_of :aluno_nome,:aluno_mae, :aluno_ra


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
   if  !self.aluno_conjuge.nil?
      self.aluno_conjuge.upcase!
   end



  end


end
