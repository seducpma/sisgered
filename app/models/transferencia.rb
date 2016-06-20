class Transferencia < ActiveRecord::Base
   belongs_to :aluno
   belongs_to :unidade
   belongs_to :classe
   before_save :atribui, :gera_aluno_classe, :teste, :maiusculo


def maiusculo
    if  !self.para.nil?
          self.para.upcase!
    end
    if  !self.de.nil?
          self.de.upcase!
    end
end

  def teste
   if self.classe_id.nil?
      aluno_t= Aluno.find(:all, :conditions =>['id = ?',self.aluno_id])
      aluno_t.each do |aluno|
         aluno.aluno_status = 'TRANSFERIDO'
         aluno.save
      end
   end

   


    
  end

   def atribui
    self.unidade_id = User.current.unidade_id
    self.ano_letivo = Time.now.year
  end

  def gera_aluno_classe
    
    classe = AlunosClasse.new
    classe.classe_id = self.classe_id
    classe.aluno_id = self.aluno_id


    aluno_trans_i = Aluno.find(:all, :conditions => ["id =?" , self.aluno_id])
    aluno_trans_i.each do |aluno|
      aluno.trans_in = 1
      aluno.unidade_anterior = aluno.unidade_id
      aluno.unidade_id = self.unidade_id
      aluno.transferido = self.data_transferencia
      aluno.save
    end
    

  end



end
