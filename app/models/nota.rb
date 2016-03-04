class Nota < ActiveRecord::Base
  
  belongs_to :classe
  belongs_to :professor
  has_and_belongs_to_many :alunos
end
