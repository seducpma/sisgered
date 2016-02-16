class Nota < ActiveRecord::Base
  
  belongs_to :unidade
  belongs_to :professo
  has_and_belongs_to_many :alunos
end
