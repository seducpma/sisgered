class Ata < ActiveRecord::Base
  belongs_to :unidade
  validates_presence_of :titulo, :quant, :unidade_id
  before_save  :maiusculo



 def maiusculo
   if  !self.moderador.nil?
       self.moderador.upcase!
   end
   if  !self.titulo.nil?
    self.titulo.upcase!
   end
   if  !self.secretario.nil?
    self.secretario.upcase!
   end

 end


end
