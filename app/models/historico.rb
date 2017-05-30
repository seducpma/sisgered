class Historico < ActiveRecord::Base
    before_save  :maiusculo


  def maiusculo
    if  !self.observacao.nil?
          self.observacao.upcase!
    end
    if  !self.quem.nil?
          self.quem.upcase!
    end
  end

 
 CLASSES =%w(1 2 3 4 5 6 7 8 9)



 
end
