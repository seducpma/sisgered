class Funcionario < ActiveRecord::Base



CIVIL = %w(SOLTEIRO(A) CASADO(A) DIVORCIADO(A) VIÚVO(A) UNIÃO_ESTÁVEL OUTROS)
SEXO = %w(MASCULINO FEMININO HOMOAFETIVO)
PARTICIPANTE = %w(SIM NÃO ESPORÁDICO)

  belongs_to :unidade
  has_attached_file :photo, :styles => {:small => "150x150>" }
  has_many :familiares
  #has_and_belongs_to_many :familiares
  after_create :salva_familiar
validates_presence_of :unidade_id, :message => ' Selecionar EMPRESA'
 def salva_familiar
   t=Familiare.all(:conditions =>["funcionario_id is null"])
   t.each do |f|
     f.funcionario_id = self.id
     f.save
   end
  
 end


end
