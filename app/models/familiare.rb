class Familiare < ActiveRecord::Base

   belongs_to :funcionario
     #has_and_belongs_to_many :funcionarios

    validates_presence_of :unidade_id, :message => ' Selecionar EMPRESA'

  CIVIL = %w(--Selecionar-- SOLTEIRO(A) CASADO(A) DIVORCIADO(A) VIÚVO(A) UNIÃO_ESTÁVEL OUTROS)
  PARENTESCO = %w(-Selecionar- PAI MÃE SOGRO(A) IRMÃ(0) PRIMO(A) TIO(A) AMIGO(A) OUTROS)
 end
