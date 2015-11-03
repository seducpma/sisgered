class Crianca < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :regiao
  belongs_to :unidade

  validates_presence_of :unidade_id
  validates_presence_of :regiao_id
  validates_presence_of :nome
  validates_presence_of :mae
  validates_presence_of :nascimento
  validates_presence_of :opcao1
  before_save  :maiusculo, :opcao


 Status = %w(NA_DEMANDA CANCELADA MATRICULADA)

def self.na_demanda
    Crianca.find(:all, :conditions => {:status => 'NA_DEMANDA' })
  end

 def self.matriculada
    Crianca.find(:all, :conditions => {:status => 'MATRICULADA' })
  end


 def self.cancelada
    Crianca.find(:all, :conditions => {:status => 'CANCELADA' })
  end


  def self.total_demanda
    Crianca.find(:all)
  end

 def opcao
    data=self.nascimento

  if  (self.nascimento <= '2015-10-31'.to_date and self.nascimento >= '2015-02-01'.to_date)
       self.grupo_id = 1
  else if(self.nascimento <= '2015-01-31'.to_date and self.nascimento >= '2014-07-01'.to_date)
          self.grupo_id = 2
       else if(self.nascimento <= '2014-06-30'.to_date and self.nascimento >= '2013-07-01'.to_date)
              self.grupo_id = 4
            else if(self.nascimento <= '2013-06-30'.to_date and self.nascimento >= '2012-07-01'.to_date)
                    self.grupo_id = 5
                  else if(self.nascimento <= '2012-06-30'.to_date and self.nascimento >= '2011-07-01'.to_date)
                          self.grupo_id = 6
                        else if(self.nascimento <= '2011-06-30'.to_date and self.nascimento >= '2010-07-01'.to_date)
                               self.grupo_id = 7
                             end
                       end
                 end
            end
       end
  end
 end


  def self.demanda_total
    Crianca.find(:all, :conditions => ["status = 'NA_DEMANDA'"])

  end


   def self.matricula_total
    Crianca.find(:all, :conditions => ["status = 'MATRICULADA'"])
  end
  def maiusculo
    self.nome.upcase!
    self.bairro.upcase!
    self.complemento.upcase!
    self.mae.upcase!
    self.necessidade.upcase!
    self.pai.upcase!
    self.endereco.upcase!
    self.responsavel_n.upcase!
    self.parentesco.upcase!
    self.local_trabalho.upcase!
    self.servidor_local.upcase!
    self.nomerecado.upcase!
    self.status.upcase!
  end
end
