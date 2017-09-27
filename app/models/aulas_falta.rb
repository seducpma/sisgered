class AulasFalta < ActiveRecord::Base
  belongs_to :professor
  belongs_to :funcionario
  belongs_to :unidade

   before_save  :maiusculo

  def maiusculo
    if  !self.funcao.nil?
          self.funcao.upcase!
    end
    if  !self.obs.nil?
          self.obs.upcase!
    end
  end
end
