class Eventual < ActiveRecord::Base
  belongs_to :professor
   belongs_to :unidade

   before_save :caps_look

 def caps_look
    if  !self.disponibilidade.nil?
          self.disponibilidade.upcase!
    end
    if  !self.obs.nil?
          self.obs.upcase!
    end

  end


end
