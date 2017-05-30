class ObservacaoHistorico < ActiveRecord::Base
  belongs_to :aluno


  before_save :caps_look

  def caps_look

    if  !self.observacao.nil?
          self.observacao.upcase!
    end
    if  !self.quem.nil?
          self.quem.upcase!
    end
  
  end
  
end
