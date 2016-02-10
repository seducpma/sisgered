class Saude < ActiveRecord::Base
  belongs_to :aluno
  before_save  :maiusculo
  before_save  :atribui_unidade
  belongs_to :unidade




  def atribui_unidade

    self.unidade_id = User.current.unidade_id

  end

  def maiusculo
    self.saude_necessidade_especial.upcase!
    self.saude_neuropsico.upcase!
    self.saude_alergia.upcase!
    self.saude_alergia.upcase!
    self.saude_antecedentes_mae.upcase!
    self.saude_intolerancia.upcase!
    self.saude_medicamento.upcase!
    self.saude_antipiretico.upcase!
    self.saude_pelicilina.upcase!
    self.saude_cirurgia.upcase!
    self.saude_fratura.upcase!
    self.saude_probl_visao.upcase!
    self.saude_hospitalizado.upcase!
    self.saude_fumante_casa.upcase!
    self.saude_dependetes_quimicos.upcase!
    if  !self.saude_obs.nil?
      self.saude_obs.upcase!
    end


  end

end
