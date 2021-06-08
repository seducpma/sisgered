class AtendimentoAee < ActiveRecord::Base
  belongs_to :classe
  belongs_to :aluno
  belongs_to :unidade
  has_many :notas, :dependent => :destroy
  has_many :faltas, :dependent => :destroy
  has_many :atividade_avaliacaos, :dependent => :destroy



end
