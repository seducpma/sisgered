class Professor < ActiveRecord::Base

  belongs_to :unidade
  has_many :atribuicaos
  has_many :notas
  has_many :users
  has_many :relatorios
  has_many :eventuals
  
  #has_one :tempo_servico, :dependent => :delete
  #has_one :titulo_professor, :dependent => :delete

validates_presence_of :matricula, :message => ' -  MATRÍCULA - PREENCHIMENTO OBRIGATÓRIO'
validates_presence_of :nome, :message => ' -  NOME - PREENCHIMENTO OBRIGATÓRIO'
validates_presence_of :funcao, :message => ' -  FUNÇÃO - PREENCHIMENTO OBRIGATÓRIO'
validates_presence_of :unidade_id, :message => ' -  SEDE - PREENCHIMENTO OBRIGATÓRIO'

validates_numericality_of :INEP, :only_integer => true, :message =>  ' - SOMENTE NÚMEROS'
validates_numericality_of :RD, :only_integer => true, :message =>  ' - SOMENTE NÚMEROS'
validates_uniqueness_of :matricula, :message => ' - PROFESSOR JA CADASTRADO'
Curso = ['SEM MAGISTÉRIO / PEDAGOGIA','MAGISTÉRIO - NÍVER MÉDIO','PEDAGOGIA / NORMAL SUPERIOR','LICENCIATURA EM ARTES','LICENCIATURA EM EDUCAÇÃO FÍSICA','LICENCIATURA Em LETRAS - PORTUGUÊS','LICENCIATURA EM LETRAS - INGLÊS','LICENCIATURA EM MATEMÁTICA','LICENCIATRUA EM HISTÓRIA','LICENCIATURA EM GEOGRAFIA','LICENCIATURA EM CIÊNCIAS / BIOLOGIA']

  #after_create :log_cadastro
  before_update :atualiza
  before_save :caps_look

  def atualiza
   atualiza = Professor.find(self.id)
   if self.dt_nasc.nil?
        self.dt_nasc = atualiza.dt_nasc
   end
   if self.dt_ingresso.nil?
        self.dt_ingresso = atualiza.dt_ingresso
   end

  end

  def caps_look
    self.pontuacao_final = (self.total_trabalhado + self.total_titulacao)

    self.nome.upcase!
  if !self.endres.nil?
    self.endres.upcase!
  end
  if !self.bairro.nil?
    self.bairro.upcase!
  end
  if !self.complemento.nil?
    self.complemento.upcase!
  end
  if !self.cidade.nil?
    self.cidade.upcase!
  end
  if !self.funcao.nil?
    self.funcao.upcase!
  end
   if !self.obs.nil?
    self.obs.upcase!
   end

  end






end
