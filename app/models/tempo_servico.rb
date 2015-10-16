class TempoServico < ActiveRecord::Base
  validates_presence_of :professor_id, :message => ' -  PROFESSOR - PREENCHIMENTO OBRIGATÓRIO'
  has_many :relatorios
  has_many :unidades
  has_many :users
  belongs_to :professor
  before_save :salva_dados,  :pontuacao_anterior,  :total_geral,  :geral, :total_pontuacao

  def salva_dados

    self.ano_letivo = Time.current.strftime("%Y").to_i
    self.ano1 = (Time.current.strftime("%Y").to_i)-1
    self.ano2 = Time.current.strftime("%Y").to_i

    self.dias_trab1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1))
    self.dias_trab2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2))
  
      if self.unidade1 == 0
        self.dias_unidade1 = 0
      else
        self.dias_unidade1 = self.unidade1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1)
      end
      self.dias_rede1 = self.dias1 + self.outro_trab1
      if self.unidade2 == 0
        self.dias_unidade2 = 0
      else
        self.dias_unidade2 = self.unidade2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2)
      end
      self.dias_rede2 = self.dias2 + self.outro_trab2

    verificando1 = ((self.f_abonada1) + (self.f_atestado1) + (self.lic_saude1) + (self.outras_aus1))
    verificando2 = ((self.f_abonada2) + (self.f_atestado2) + (self.lic_saude2) + (self.outras_aus2))
    if (verificando1  <= 15)
        self.dias_efetivos1 = self.dias1 - (self.f_justif1 + self.f_injustif1 + self.afastamento1)
    else
       self.dias_efetivos1 = self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.lic_saude1 + self.f_justif1 + self.f_injustif1 + self.afastamento1 + self.outras_aus1)
    end
    verificando2 = ((self.f_abonada2) + (self.f_atestado2) + (self.lic_saude2) + (self.outras_aus2))
    if (verificando1  <= 15)
        self.dias_efetivos2 = self.dias2 - (self.f_justif2 + self.f_injustif2 + self.afastamento2)
    else
       self.dias_efetivos2 = self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.lic_saude2 + self.f_justif2 + self.f_injustif2 + self.afastamento2 + self.outras_aus2)
    end

    self.subtot_dias = self.dias_trab1 + self.dias_trab2
    self.subtot_efetivo = self.dias_efetivos1 + self.dias_efetivos2
    self.subtot_rede = self.dias_rede1 + self.dias_rede2
    self.subtot_unid = self.dias_unidade1 + self.dias_unidade2

  end


end
def pontuacao_anterior
  profant=$teacher
  anoanteiror =  ((Time.current.strftime("%Y").to_i)-1)
  @total_anterior = TempoServico.find(:all , :conditions => ['professor_id =? and ano_letivo = ?',$teacher, anoanteiror])

  if ((@total_anterior.nil?) or (@total_anterior.empty?))
     self.total_ant_dias= 0
     self.total_ant_efetivo= 0
     self.total_ant_rede= 0
     self.total_ant_unid= 0
  else
    @total_anterior.each do |tp|
      $dias = tp.total_dias
      $efetivo = tp.total_efetivo
      $rede = tp.total_rede
      $unid = tp.total_unid
    end

     self.total_ant_dias= $dias
     self.total_ant_efetivo= $efetivo
     self.total_ant_rede= $rede
     self.total_ant_unid= $unid

  end


  def total_geral
    self.total_dias= (self.total_ant_dias + self.dias_trab1 + self.dias_trab2 ) * 8
    self.total_efetivo= (self.total_ant_efetivo + self.dias_efetivos1 + self.dias_efetivos2) * 2
    self.total_rede= (self.total_ant_rede + self.dias_rede1 + self.dias_rede2) * 1
    self.total_unid= (self.total_ant_unid +  self.dias_unidade1 + self.dias_unidade2) * 2
end

  def geral
    self.total_geral_tempo_servico = self.total_dias + self.total_efetivo + self.total_rede + self.total_unid
  end

  def total_pontuacao
    $ano =  Time.current.strftime("%Y").to_i
    t =$teacher
    @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo = ? and titulacaos.tipo = 'ANUAL'", $teacher,$ano] )
    if @tp.empty?
      $pontostitulo=0
    else
      @tp.each do |tp|
        $pontostitulo= (tp.total_titulacao)
      end
    end
     self.pontuacao_geral = self.total_geral_tempo_servico + $pontostitulo
    end
end
