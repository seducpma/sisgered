class Socioeconomico < ActiveRecord::Base
  belongs_to :aluno
  belongs_to :unidade
  before_save  :maiusculo
  before_save  :atribui_unidade

  def atribui_unidade

    self.unidade_id = User.current.unidade_id

  end



  def maiusculo

    self.economico_irmaos.upcase!
    if  !self.economico_obs.nil?
      self.economico_obs.upcase!
    end


  end
end
